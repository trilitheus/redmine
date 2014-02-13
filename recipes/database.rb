# Create database and user
%w{mysql::server mysql::ruby}.each do |recipe|
  include_recipe recipe
end
# define mysql connection info
gem_package 'mysql'

mysql_connection_info = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# create database
mysql_database 'redmine' do
  connection mysql_connection_info
  action :create
end

# create database user
mysql_database_user 'redmine' do
  connection mysql_connection_info
  password 'redmine'
  database_name 'redmine'
  privileges [:all]
  action [:create, :grant]
end
