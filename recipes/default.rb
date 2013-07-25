#
# Cookbook Name:: redmine/
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
#ENV['ARCHFLAGS'] = "-arch i386"
#include_recipe "postgresql::ruby"
bash "Create redmine user" do
  not_if "getent passwd redmine"
  code <<-EOF
groupadd redmine
useradd -g redmine -d /srv/redmine -s /bin/bash -m redmine
EOF
end

%w{libmagic-dev libmagickwand-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{mysql::server subversion application}.each do |recipe|
  include_recipe recipe
end 

#rbenv_ruby "1.9.3-p392" do
#  global true
#  force true
#end

#rbenv_gem "bundler" do
#  ruby_version "1.9.3-p392"
#end

### Create database and user
# define mysql connection info
gem_package "mysql"
chef_gem "mysql2"

mysql_connection_info = {
  :host => "localhost",
  #:port => node[:mysql][:config][:port],
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

# create database
mysql_database "redmine" do
  connection mysql_connection_info
  action :create
end

# create database user
mysql_database_user "redmine" do
  connection mysql_connection_info
  password "redmine"
  database_name "redmine"
  privileges [:all]
  action [:create, :grant]
end

include_recipe "redmine::application"
