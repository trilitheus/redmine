# Create shared dirs and configs
%w{/shared
   /shared/config
   /shared/log
   /shared/pids
   /shared/sockets
   /shared/system
   /shared/files
   /shared/vendor
   /shared/plugins
   /shared/script
  }.each do |dir|
  directory node['redmine']['home'] + dir do
    owner node['redmine']['user']
    group node['redmine']['group']
  end
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
      environment ({ 'RAILS_ENV' => node['redmine']['environment'], 'REDMINE_LANG' => 'en-GB' })
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
  purge_before_symlink %w{plugins tmp/sockets tmp/pids log}
  symlink_before_migrate 'config/configuration.yml' => 'config/configuration.yml',
                         'config/database.yml' => 'config/database.yml',
                         'config/unicorn.rb' => 'config/unicorn.rb',
                         'script/web' => 'script/web',
                         'vendor/ruby' => 'vendor/ruby',
                         'plugins' => 'plugins'

  symlinks 'system' => 'public/system',
           'pids' => 'tmp/pids',
           'sockets' => 'tmp/sockets',
           'log' => 'log'
end

  # before_migrate do
    # Add mysql and puma to Gemfile.local and reun bundler
    # template '#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}/Gemfile.local' do
      # source 'Gemfile.local.erb'
      # owner 'redmine'
      # group 'redmine'
    # end
    # bash 'Rerun Bundler' do
      # environment 'RAILS_ENV' => 'production'
      # cwd '#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}'
      # code <<-EOF
# RAILS_ENV=production bundle install --path=#{node[:redmine][:homedir]}/shared/vendor_bundle --without development test cucumber staging
# chown -R redmine:redmine #{node[:redmine][:homedir]}
# EOF
      # not_if 'cd #{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]} && bundle list | grep \'mysql2 (\''
    # end
  # end

# end

# %w{configuration.yml puma.rb}.each do |tmpl|
#   template node['redmine']['homedir'] + '/shared/' + tmpl do
#     owner 'redmine'
#     group 'redmine'
#     mode 00644
#   end
# end

# Puma requires pids directory to exists or it cannot start
# directory node['redmine']['homedir'] + '/releases/' + node['redmine']['revision'] + '/tmp/pids' do
  # owner 'redmine'
  # group 'redmine'
# end

# %w{configuration.yml puma.rb}.each do |tmpl|
  # template node['redmine']['homedir'] + '/current/config/' + tmpl do
    # owner 'redmine'
    # group 'redmine'
    # mode 00644
    # action :create
  # end
# end

# template '/etc/nginx/sites-available/redmine' do
#   source 'nginx-redmine.erb'
  # Delay notification to allow time for link to be created
#   notifies :restart, 'service[nginx]', :delayed
# end

# link '/etc/nginx/sites-enabled/redmine' do
#   to '/etc/nginx/sites-available/redmine'
# end

# bash 'start puma' do
#   cwd node['redmine']['homedir'] +  '/current'
#   user 'redmine'
#   group 'redmine'
#   environment 'RAILS_ENV' => 'production'
#   code <<-EOF
# RAILS_ENV=production bundle exec puma --config config/puma.rb
# EOF
# end
