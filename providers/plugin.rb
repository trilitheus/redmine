# Support whyrun
def whyrun_supported?
  true
end

action :install do
  unless plugin_exists?
    converge_by("Install #{ new_resource }") do
      if new_resource.source_type == 'git'
        Chef::Log.info("GIT REPO IS SET TO #{new_resource.source}")

        git node['redmine']['home'] + '/shared/plugins/' + new_resource.name do
          repository new_resource.source
          user node['redmine']['user']
          group node['redmine']['group']
          action :checkout
          notifies :restart, 'service[redmine]', :delayed if new_resource.restart_redmine
        end

        execute "run_bundler_#{new_resource.name}" do
          environment 'RAILS_ENV' => node['redmine']['environment']
          user node['redmine']['user']
          group node['redmine']['group']
          cwd node['redmine']['home'] + '/current'
          action :run
          command 'bundle install'
          only_if new_resource.run_bundler
        end

        execute "plugin_migrate_#{new_resource.name}" do
          if Chef::Config[:http_proxy]
            environment({
              'RAILS_ENV' => node['redmine']['environment'],
              'https_proxy' => Chef::Config[:https_proxy],
              'http_proxy' => Chef::Config[:http_proxy]
            })
          else
            environment 'RAILS_ENV' => node['redmine']['environment']
          end
          user node['redmine']['user']
          group node['redmine']['group']
          cwd node['redmine']['home'] + '/current'
          command 'bundle exec rake redmine:plugins:migrate'
          action :run
          only_if new_resource.run_migrations
        end
      else
        Chef::Log.warn("Only source_type of git is currently supported - you specified #{new_resource.source_type}")
      end
    end
  end
end

action :remove do
  if @current_resource.exists
    converge_by("Remove #{ new_resource }") do
      remove_redmine_plugin
    end
  else
    Chef::Log.info "#{ @current_resource } isn't installed - can't remove."
  end
end

def load_current_resource
  set_current_resources

  if plugin_exists?(@current_resource.name)
    # TODO; populate @current_resource from existing plugin_dir
    @current_resource.exists = true
  end
end

def set_current_resources
  @current_resource = Chef::Resource::RedminePlugin.new(new_resource.name)
  @current_resource.name(new_resource.name)
  @current_resource.source(new_resource.source)
  @current_resource.source_type(new_resource.source_type) || 'git'
  @current_resource.run_bundler(new_resource.run_bundler) || false
  @current_resource.restart_redmine(new_resource.restart_redmine) || false
  @current_resource.run_migrations(new_resource.run_migrations) || false
end

def plugin_exists?(name)
  Chef::Log.debug "Checking if redmine plugin #{name} exists..."
  ::File.directory?(node['redmine']['home'] + '/shared/plugins/' + name)
end
