name             'redmine'
maintainer       'trilitheus'
maintainer_email 'trilitheus@gmail.com'
license          'All rights reserved'
description      'Installs/Configures redmine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

%w{
  apt
  mysql
  database
  subversion
  ruby_build
  git
  nginx
  build-essential
  }.each do |cb|
  depends cb
end

depends 'ohai', '~> 1.1.10'
