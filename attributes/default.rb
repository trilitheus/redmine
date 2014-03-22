default['redmine']['user'] = 'redmine'
default['redmine']['group'] = 'redmine'
default['redmine']['home'] = '/srv/redmine'

default['redmine']['dbname'] = 'redmine'
default['redmine']['dbuser'] = 'redmine'
default['redmine']['dbpass'] = 'redmine'
default['redmine']['nginx_server_names'] = ['redmine.*']

default['redmine']['version'] = '2.5-stable'
default['redmine']['url'] = 'http://svn.redmine.org/redmine/branches/' + node['redmine']['version']
default['redmine']['revision'] = '12954'

default['redmine']['environment'] = 'production'

default['redmine']['packages'] = %w{libmagic-dev libmagickwand-dev libmysqlclient-dev}

if node['platform'] == 'ubuntu' && node['platform_version'].to_f == 12.04
  default['redmine']['ruby_install'] = 'package'
else
  default['redmine']['ruby_install'] = 'build'
end
