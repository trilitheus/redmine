Redmine Cookbook
=================

[![Build Status](https://travis-ci.org/trilitheus/redmine.png?branch=master)](https://travis-ci.org/trilitheus/redmine)

This Cookbook installs and  configures redmine with nginx and unicorn.  
An LWRP is also provided to allow easy install of redmine plugins

Requirements
============

Other cookbooks required and stated in the metadata are:
*  apt
* mysql
* database
* subversion
* ruby_build
* git
* nginx
* build-essential
* ohai

Usage
=====

Add this cookbook to your node's run list.

To install a redmine plugin, the redmine_plugin resource is provided.
At present only plugins with a git source are supported.

Call this in your recipe as follows:

    redmine_plugins 'a_plugin_name' do  
      source 'http://gitrepo'  
      source_type 'git'  
      restart_bundler boolean  
      restart_redmine boolean  
    end  

Attributes
==========

* `node['redmine']['user']`
* `node['redmine']['group']`
  - Redmine service user and group for Unicorn Rails app, default 'redine'
  
* `node['redmine']['home']`
  - Redmine top-level home for service account, default '/srv/redmine'

* `node['redmine']['type']`
  - __This cookbook currently only supports mysql database__
  - The database type to use.
  - Options: 'mysql', 'postgresql'
  - Default 'mysql

* `node['redmine']['dbname']`
  - The name for the database, default 'redmine'

* `node['redmine']['dbuser']`
  - The user for the database, default 'redmine'

* `node['redmine']['dbpass']`
  - The password for the database, default 'redmine'
  - Possible to set from chef_vault

* `node['redmine']['web_fqdn']`
  - The main server name - defaults to `redmine.node['domain']`

* `node['redmine']['nginx_server_names']`
  - Server aliases, defaults to `[ 'redmine.* ]`

* `node['redmine']['version']`
  - SVN Version, default to `2.5-stable`

* `node['redmine']['url']`
  - SVN repo address, default to `http://svn.redmine.org/redmine/branches/ + node['redmine']['version']`

* `node['redmine']['revision']`
  - Redmine SVN Repo revision

* `node['redmine']['environment']`
  - The rails environment, default to 'production'

* `node['redmine']['packages']`
  - prerequisite packages to install for redmine
  - defaults to `%w{libmagic-dev libmagickwand-dev libmysqlclient-dev}`

Recipes
=======

* default

* ruby

* database

* deploy

* nginx

Author
======
Author: trilitheus (trilitheus@gmail.com)
