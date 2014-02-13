### Create database and user
# define mysql connection info
gem_package 'mysql'

mysql_connection_info = {
  :host => '127.0.0.1',
  #:port => node[:mysql][:config][:port],
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
