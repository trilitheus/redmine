#
# Cookbook Name:: redmine/
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
bash "Create redmine user" do
  not_if "getent passwd redmine"
  code <<-EOF
groupadd redmine
useradd -g redmine -d /srv/redmine -s /bin/bash -m redmine
EOF
end

%w{libmagic-dev libmagickwand-dev libpq-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{rbenv::default rbenv::ruby_build postgresql::server postgresql::ruby subversion application redmine::database redmine::application}.each do |recipe|
  include_recipe recipe
end 

rbenv_ruby "1.9.3-p392" do
  global true
  force true
end

rbenv_gem "bundler" do
  ruby_version "1.9.3-p392"
end
