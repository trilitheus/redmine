name             'redmine'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures redmine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{mysql database subversion application application_ruby ruby_build git}.each do |cb|
  depends cb
end
