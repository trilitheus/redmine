# Create nginx directories
include_recipe 'nginx::commons_dir'

template '/etc/nginx/sites-available/redmine' do
  mode '644'
  source 'nginx-redmine.erb'
  notifies :restart, 'service[nginx]'
  variables(
    :redmine_app_home => node['redmine']['home'] + '/current',
    :server_name => node['redmine']['nginx_server_names'].join(' '),
    :port => '80'
  )
end

include_recipe 'nginx'

nginx_site 'redmine' do
  enable true
end

nginx_site 'default' do
  enable false
end

template '/etc/init.d/redmine' do
  owner node['redmine']['user']
  group node['redmine']['group']
  mode '750'
  variables(
    :redmine_app_home => node['redmine']['home'] + '/current',
    :redmineuser => node['redmine']['user']
  )
end

service 'redmine' do
  supports restart: true, reload: true
  action [:enable, :start]
end
