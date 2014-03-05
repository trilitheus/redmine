require 'spec_helper'

describe 'redmine::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql']['server_debian_password'] = 'password'
      node.set['mysql']['server_root_password'] = 'password'
      node.set['mysql']['server_repl_password'] = 'password'
      node.automatic['platform_family'] = 'debian'
      node.automatic['lsb']['codename'] = 'precise'
    end.converge(described_recipe)
  end

  before do
    stub_command("\"/usr/bin/mysql\" -u root -e 'show databases;'").and_return(true)
  end

  it 'should create the group redmine' do
    expect(chef_run).to create_group('redmine')
  end

  it 'should create the user redmine' do
    expect(chef_run).to create_user('redmine')
  end

  it 'should install libmagic-dev libmagickwand-dev libmysqlclient-dev' do
    %w{libmagic-dev libmagickwand-dev libmysqlclient-dev}.each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end

  it 'should include the ruby, database, deploy, nginx recipes' do
    %w{ruby database deploy nginx}.each do |rec|
      expect(chef_run).to include_recipe("redmine::#{rec}")
    end
  end

  it 'should include the subversion, git and nginx cookbooks' do
    %w{subversion git nginx}.each do |ckbk|
      expect(chef_run).to include_recipe(ckbk)
    end
  end

  it 'should render the /etc/subversion/servers file' do
    expect(chef_run).to render_file('/etc/subversion/servers')
  end
end
