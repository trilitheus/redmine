# Create shared dir and add config and puma templates
directory "#{node[:redmine][:homedir]}/shared" do
  owner "redmine"
  group "redmine"
end

template "#{node[:redmine][:homedir]}/shared/configuration.yml" do
      owner "redmine"
      group "redmine"
      mode 00644
end

template "#{node[:redmine][:homedir]}/shared/puma.rb" do
      owner "redmine"
      group "redmine"
      mode 00644
end

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
  environment "RAILS_ENV" => "production"
  symlink_before_migrate = { "config/database.yml" => "config/database.yml",
                             "config/puma.rb" => "config/puma.rb",
                             "config/application.yml" => "config/application.yml"
                           }
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
    #template "#{node[:redmine][:homedir]}/shared/configuration.yml" do
      #owner "redmine"
      #group "redmine"
      #mode 00644
    #end
    #template "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}/Gemfile.local" do
      #source "Gemfile.local.erb"
      #owner "redmine"
      #group "redmine"
    #end
    bash "ReRun Bundler" do
      environment "RAILS_ENV" => "production"
      cwd "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}"
      code <<-EOF
RAILS_ENV=production bundle install --path=#{node[:redmine][:homedir]} --without development test cucumber staging 
chown -R redmine:redmine #{node[:redmine][:homedir]}
EOF
    end
  end

  #passenger_apache2 do
  #end
end
