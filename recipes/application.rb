# Set up and deploy application
application "redmine" do
  owner "redmine"
  group "redmine"
  scm_provider Chef::Provider::Subversion
  path "#{node[:redmine][:homedir]}"
  repository "http://svn.redmine.org/redmine/branches/2.3-stable"
  revision "HEAD"
  migrate true
  rails do
    bundler true
    database do
      database "redmine"
      username "redmine"
      password "redmine"
      adapter "postgresql"
      host "localhost"
      encoding "utf8"
    end
  end

  before_migrate do
    rbenv_ruby "1.9.3-p392" do
      global true
    end

    rbenv_gem "bundler" do
      ruby_version "1.9.3-p392"
    end
  end

  passenger_apache2 do
  end
end

template "/srv/redmine/current/config/configuration.yml" do
  owner "redmine"
  group "redmine"
  mode 00644
  action :create
end
