### Create database and user

# define postgresql connection info
postgresql_connection_info = {
  :host => "127.0.0.1",
  :port => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

# create database
postgresql_database "redmine" do
  connection postgresql_connection_info
  action :create
end

# create database user
postgresql_database_user "redmine" do
  connection postgresql_connection_info
  password "redmine"
  database_name "redmine"
  privileges [:all]
  action [:create, :grant]
end
