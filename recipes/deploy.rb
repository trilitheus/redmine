# Create shared dirs and configs
%w(/shared
   /shared/config
   /shared/log
   /shared/pids
   /shared/sockets
   /shared/system
   /shared/files
   /shared/vendor
   /shared/plugins
   /shared/script
).each do |dir|
  directory node['redmine']['home'] + dir do
    owner node['redmine']['user']
    group node['redmine']['group']
  end
end

# Create the locale file
template node['redmine']['home'] + '/shared/config/en-GB.yml' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '640'
  action :create
end

# Set protocol to https or http
protocol = (node['redmine']['https'] ? 'https' : 'http')

# Create the settings file
template node['redmine']['home'] + '/shared/config/settings.yml' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '640'
  variables(
    :weburl => node['redmine']['web_url'],
    :protocol => protocol,
    :inactivity_timeout => node['redmine']['inactivity_timeout']
  )
  action :create
  notifies :restart, 'service[redmine]'
end

# Create the database config
template node['redmine']['home']  + '/shared/config/database.yml' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '640'
  variables(
    :database => node['redmine']['dbname'],
    :dbuser => node['redmine']['user'],
    :dbpass => node['redmine']['dbpass']
  )
  action :create
end

# Create the application config
template node['redmine']['home'] + '/shared/config/configuration.yml' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '640'
  variables(
    :filesdir => node['redmine']['home'] + '/shared/files'
  )
  action :create
end

template node['redmine']['home'] + '/shared/config/unicorn.rb' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '640'
  variables(
    :fqdn => node['fqdn'],
    :redmine_app_home => node['redmine']['home'] + '/current'
  )
end

cookbook_file node['redmine']['home'] + '/shared/script/web' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '750'
end

# Deploy the application to the app dir
deploy_revision node['redmine']['home'] do
  repo node['redmine']['url']
  revision node['redmine']['revision']
  user node['redmine']['user']
  group node['redmine']['group']
  environment 'RAILS_ENV' => node['redmine']['environment']
  scm_provider Chef::Provider::Subversion

  migrate true
  migration_command "cd #{node['redmine']['home']}/releases/#{node['redmine']['revision']}; bundle exec rake db:migrate --trace"

  before_restart do
    execute 'load_default_data' do
      environment('RAILS_ENV' => node['redmine']['environment'], 'REDMINE_LANG' => 'en-GB')
      user node['redmine']['user']
      group node['redmine']['group']
      cwd node['redmine']['home'] + '/releases/' + node['redmine']['revision']
      command 'bundle exec rake redmine:load_default_data --trace'
    end
  end

  before_migrate do
    cookbook_file release_path + '/Gemfile.local' do
      user node['redmine']['user']
      group node['redmine']['group']
      mode '640'
      action :create
    end

    execute 'bundle_install' do
      environment 'RAILS_ENV' => node['redmine']['environment']
      user node['redmine']['user']
      group node['redmine']['group']
      cwd node['redmine']['home'] + '/releases/' + node['redmine']['revision']
      command "bundle install --path #{node['redmine']['home']}/shared/vendor"
    end
  end

  action :deploy
  purge_before_symlink %w(plugins tmp/sockets tmp/pids log)
  symlink_before_migrate 'config/configuration.yml' => 'config/configuration.yml',
                         'config/database.yml' => 'config/database.yml',
                         'config/settings.yml' => 'config/settings.yml',
                         'config/unicorn.rb' => 'config/unicorn.rb',
                         'config/en-GB.yml' => 'config/locales/en-GB.yml',
                         'script/web' => 'script/web',
                         'vendor/ruby' => 'vendor/ruby',
                         'plugins' => 'plugins'

  symlinks 'system' => 'public/system',
           'pids' => 'tmp/pids',
           'sockets' => 'tmp/sockets',
           'log' => 'log'
end
