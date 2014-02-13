default['redmine']['user'] = 'redmine'
default['redmine']['group'] = 'redmine'
default['redmine']['home'] = '/srv/redmine'

default['redmine']['version'] = '2.4-stable'
default['redmine']['url'] = 'http://svn.redmine.org/redmine/branches/' + node['redmine']['version']
default['redmine']['revision'] = '12879'

default['redmine']['packages'] = %w{libmagic-dev libmagickwand-dev libmysqlclient-dev}

if node['platform'] == 'ubuntu' && node['platform_version'].to_f == 12.04
  default['redmine']['ruby_install'] = 'package'
else
  default['redmine']['ruby_install'] = 'build'
end

override['nginx']['default_site_enabled'] = false
override['nginx']['client_max_body_size'] = '50m'

override['postgresql']['config_pgtune']['db_type'] = 'web'
override['postgresql']['enable_pgdg_apt'] = true
