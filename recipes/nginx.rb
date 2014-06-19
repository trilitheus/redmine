# Create nginx directories
include_recipe 'nginx::commons_dir'

listen_port = node['redmine']['listen_port'] || (node['redmine']['https'] ? 443 : 80)

directory '/etc/nginx/ssl' do
  user 'root'
  group 'root'
  mode 00755
  action :create
end

chef_vault_file "/etc/nginx/ssl/#{node['redmine']['ssl_key']}" do
  vault_name node['redmine']['vault_name']
  vault_item node['redmine']['ssl_key'].gsub('.', '_')
end

chef_vault_file "/etc/nginx/ssl/#{node['redmine']['ssl_crt']}" do
  vault_name node['redmine']['vault_name']
  vault_item node['redmine']['ssl_crt'].gsub('.', '_')
end

template '/etc/nginx/sites-available/redmine' do
  owner 'root'
  group 'root'
  mode 00644
  source 'nginx-redmine.erb'
  notifies :restart, 'service[nginx]'
  variables(
    :server_name => node['redmine']['nginx_server_names'].join(' '),
    :redmine_app_home => node['redmine']['home'] + '/current',
    :https_boolean => node['redmine']['https'],
    :ssl_certificate_key => "/etc/nginx/ssl/#{node['redmine']['ssl_key']}",
    :ssl_certificate => "/etc/nginx/ssl/#{node['redmine']['ssl_crt']}",
    :listen => "#{node['redmine']['listen_ip']}:#{listen_port}"
  )
end

include_recipe 'nginx'

nginx_site 'redmine' do
  enable true
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
