redmine Cookbook CHANGELOG
==========================
v1.2.2
------
* Fixed do end issues

v1.2.1
------
* Removed any chef-vault reference - deal with in a wrapper as we don't want to be too opinionated about

v1.2.0
------
* Removed any chef-vault reference - deal with in a wrapper as we don't want to be too opinionated about
  people having to use chef-vault in place of traditional encrypted data bags or another method.

v1.1.0
------
* Added ability to specify revision for redmine plugins - tagged at 1.1.0

v1.0.4
------
* attributised the inactivity_timeout into settings.yml template

v1.0.3
------
* templated the protocol (http or https) into settings.yml template

v1.0.2
------
* removed disable of nginx default site

v1.0.1
------
* added settings.yml to be managed

v1.0.0
------
* Bumped to first release version

v0.1.5
------
* Added SSL

v0.1.4
------
* Refactored pluin provider

v0.1.3
------
* removed current part of app home in template directory as already specificed in recipe

v0.1.1
------
* Changed LWRP to just be named plugin so can be called via redmine_plugin

v0.1.0
------
* First draft of redmine cookbook - runs to install
