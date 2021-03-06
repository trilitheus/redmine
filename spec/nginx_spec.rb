require 'spec_helper'

describe 'redmine::nginx' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql']['server_debian_password'] = 'password'
      node.set['mysql']['server_root_password'] = 'password'
      node.set['mysql']['server_repl_password'] = 'password'
      node.automatic['platform_family'] = 'debian'
      node.automatic['lsb']['codename'] = 'precise'
    end.converge(described_recipe)
  end

  it 'should include nginx::commons_dir recipe' do
    expect(chef_run).to include_recipe('nginx::commons_dir')
  end

  it 'should create the nginx virtualhost file' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/redmine')
  end

  it 'create the directory /etc/nginx/ssl' do
    expect(chef_run).to create_directory('/etc/nginx/ssl')
  end

end
