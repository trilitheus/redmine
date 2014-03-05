require 'spec_helper'

describe 'redmine::ruby' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql']['server_debian_password'] = 'password'
      node.set['mysql']['server_root_password'] = 'password'
      node.set['mysql']['server_repl_password'] = 'password'
      node.set['redmine']['ruby_install'] = 'package'
      node.automatic['platform_family'] = 'debian'
      node.automatic['lsb']['codename'] = 'precise'
    end.converge(described_recipe)
  end

  it 'should install the ruby1.9.3 package' do
    expect(chef_run).to install_package('ruby1.9.3')
  end

  it 'should install the bundler gem' do
    expect(chef_run).to install_gem_package('bundler')
  end
end
