#
# Cookbook Name:: redmine/
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#
%w{postgresql::server subversion redmine::database}.each do |recipe|
  include_recipe recipe
end 
