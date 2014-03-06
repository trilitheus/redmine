# Support whyrun
def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists - nothing to do."
  else
    converge_by("Install #{ @new_resource }") do
      install_redmine_plugin
    end
  end
end

action :remove do
  if @current_resource.exists
    converge_by("Remove #{ @new_resource }") do
      remove_redmine_plugin
    end
  else
    Chef::Log.info "#{ @current_resource } isn't installed - can't remove."
  end
end

def load_current_resource
  @current_resource = Chef::Resource::RedminePlugin.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.source(@new_resource.source)
  @current_resource.source_type(@new_resource.source_type) || 'git'
  @current_resource.run_bundler(@new_resource.source_type) || false
  @current_resource.restart_redmine(@new_resource.source_type) || false

  if plugin_exists?(@current_resource.name)
    # TODO; populate @current_resource from existing plugin_dir
    @current_resource.exists = true
  end
end

def install_redmine_plugin
  plugin_name = new_resource.name
  plugin_source = new_resource.source
  plugin_source_type = new_resource.source_type
  plugin_run_bundler = new_resource.run_bundler
  plugin_restart_redmine = new_resource.restart_redmine

  # We only support git as a plugin source for now
  case plugin_source_type
  when 'git'
    git node['redmine']['home'] + '/shared/plugins/' + plugin_name do
      repository plugin_source
      user node['redmine']['user']
      group node['redmine']['group']
      action :checkout
    end
    execute 'plugin_migrate' do
      environment 'RAILS_ENV' => node['redmine']['environment']
      user node['redmine']['user']
      group node['redmine']['group']
      cwd node['redmine']['home'] + '/current'
      command 'bundle exec rake redmine:plugins:migrate'
      notifies :run, 'execute[run_bundler]', :immediately if plugin_run_bundler
      notifies :restart, 'service[redmine]', :delayed if plugin_restart_redmine
    end
    execute 'run_bundler' do
      environment 'RAILS_ENV' => node['redmine']['environment']
      user node['redmine']['user']
      group node['redmine']['group']
      cwd node['redmine']['home'] + '/current'
      action :nothing
      command 'bundle install'
    end
  else
    Chef::Log.warn "#{plugin_source_type} not supported."
  end
end
