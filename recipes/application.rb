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
 
  #svn_arguments "--config-dir=/etc/subversion" # not accepted - more to learn # there is way to pass this to deploy_revision resource but how?
  path "#{node[:redmine][:homedir]}"
  repository "http://svn.redmine.org/redmine/branches/2.3-stable"
  revision "12040"
  migrate true
  environment "RAILS_ENV" => "production"
  #                         }
  symlink_before_migrate = { "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}/config/database.yml" => "#{node[:redmine][:homedir]}/shared/database.yml",
                             "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}/config/puma.rb" => "#{node[:redmine][:homedir]}/shared/puma.rb",
                             "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}/config/application.yml" => "#{node[:redmine][:homedir]}/shared/application.yml"
                           }
  #action :force_deploy
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
    # Add mysql to gemfile and rerun bundler
    template "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}/Gemfile.local" do
      source "Gemfile.local.erb"
      owner "redmine"
      group "redmine"
    end
    bash "Rerun Bundler" do
      environment "RAILS_ENV" => "production"
      cwd "#{node[:redmine][:homedir]}/releases/#{node[:redmine][:revision]}"
      code <<-EOF
RAILS_ENV=production bundle install --path=#{node[:redmine][:homedir]}/shared/vendor_bundle --without development test cucumber staging 
chown -R redmine:redmine #{node[:redmine][:homedir]}
EOF
    end
  end

  #passenger_apache2 do
  #end
end

template "/etc/nginx/sites-available/redmine" do
  source "nginx-redmine.erb"
  notifies :restart, "service[nginx]", :delayed
end

link "/etc/nginx/sites-enabled/redmine" do
  to "/etc/nginx/sites-available/redmine"
end
