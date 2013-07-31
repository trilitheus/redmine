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

%w{libmagic-dev libmagickwand-dev libmysqlclient-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{mysql::server mysql::ruby subversion git application ruby_build nginx}.each do |recipe|
  include_recipe recipe
end 

### Create database and user
# define mysql connection info
mysql_connection_info = {
  :host => "localhost",
  #:port => node[:mysql][:config][:port],
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

# install local ruby
include_recipe 'ruby_build'
ruby_build_ruby '1.9.3-p362' do
    prefix_path '/usr/local/'
    environment 'CFLAGS' => '-g -O2'
    action :install
end

gem_package "bundler"

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
