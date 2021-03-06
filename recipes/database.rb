# Create database and user
%w(mysql::server mysql::ruby).each do |recipe|
  include_recipe recipe
end
# define mysql connection info
gem_package 'mysql'

mysql_connection_info = {
  :host => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

# create database
mysql_database node['redmine']['dbname'] do
  connection mysql_connection_info
  action :create
end

# create database user
mysql_database_user node['redmine']['user'] do
  connection mysql_connection_info
  password node['redmine']['dbpass']
  database_name node['redmine']['dbname']
  privileges [:all]
  action [:create, :grant]
end
