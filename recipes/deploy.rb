# Create shared dir and add config and puma templates
directory node['redmine']['home']  + '/shared' do
  owner 'redmine'
  group 'redmine'
end

# Set up and deploy application
# application 'redmine' do
  # owner node['redmine']['user']
  # group node['redmine']['group']
  # rollback_on_error false
  # scm_provider Chef::Provider::Subversion

  # svn_arguments '--config-dir=/etc/subversion' # not accepted - more to learn # there is way to pass this to deploy_revision resource but how?
  # path node['redmine']['homedir']
  # repository 'http://svn.redmine.org/redmine/branches/2.3-stable'
  # revision node['redmine']['revision']
  # migrate true
  # environment 'RAILS_ENV' => 'production'
  # action :force_deploy
  # rails do
    # bundler true
    # database do
      # database 'redmine'
      # username 'redmine'
      # password 'redmine'
      # adapter 'mysql2'
      # host 'localhost'
      # encoding 'utf8'
    # end
  # end

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
