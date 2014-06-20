name             'redmine'
maintainer       'trilitheus'
maintainer_email 'trilitheus@gmail.com'
license          'All rights reserved'
description      'Installs/Configures redmine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.0'

%w(
  apt
  database
  subversion
  ruby_build
  git
  nginx
  build-essential
  ).each do |cb|
  depends cb
end

depends 'ohai', '~> 1.1.10'
depends 'mysql', '~> 3.0.2'
