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
  @current_resource.source_type(@new_resource.source_type)
end
