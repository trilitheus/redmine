# Set up and deploy application
application "redmine" do
  owner "redmine"
  group "redmine"
  rollback_on_error false
  scm_provider Chef::Provider::Subversion
  path "#{node[:redmine][:homedir]}"
  repository "http://svn.redmine.org/redmine/branches/2.3-stable"
  revision "12040"
  migrate true
  action :force_deploy
  rails do
    bundler true
    database do
      database "redmine"
      username "redmine"
      password "redmine"
      adapter "mysql2"
      host "localhost"
      encoding "utf8"
    end
  end

  before_migrate do
    # Add mysql to gemfile and reun bundler
    execute "cd /srv/redmine/releases/12040 && sed -i '2igem \"mysql2\", \"~> 0.3.11\", :platforms => [:mri, :mingw]' Gemfile"
    execute "cd /srv/redmine/releases/12040 && sed -i '2igem \"activerecord-jdbcmysql-adapter\", :platforms => :jruby' Gemfile"
    execute "cd /srv/redmine/releases/12040 && /opt/chef/embedded/bin/bundle install --path=/srv/redmine/shared/vendor_bundle --without development test cucumber staging"
    execute "chown -R redmine:redmine /srv/redmine"
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
