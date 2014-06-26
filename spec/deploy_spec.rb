require 'spec_helper'

describe 'redmine::deploy' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql']['server_debian_password'] = 'password'
      node.set['mysql']['server_root_password'] = 'password'
      node.set['mysql']['server_repl_password'] = 'password'
      node.automatic['platform_family'] = 'debian'
      node.automatic['lsb']['codename'] = 'precise'
    end.converge(described_recipe)
  end

  %w(shared
     shared/config
     shared/log
     shared/pids
     shared/system
     shared/sockets
     shared/files
     shared/vendor
     shared/plugins
     shared/script
).each do |dir|
    it "should create redmine's shared directory #{dir}" do
      expect(chef_run).to create_directory("/srv/redmine/#{dir}").with(user: 'redmine', group: 'redmine')
    end
  end

  %w(config/database.yml
     config/configuration.yml
     config/unicorn.rb
     config/en-GB.yml
     config/settings.yml
).each do |file|
    it "should create_template /srv/redmine/shared/#{file}" do
      expect(chef_run).to create_template("/srv/redmine/shared/#{file}")
    end
  end

  it 'should create cookbook_file /srv/redmine/shared/script/web' do
    expect(chef_run).to create_cookbook_file('/srv/redmine/shared/script/web')
  end

  it 'should create_template the redmine init script' do
    expect(chef_run).to create_template('/etc/init.d/redmine')
  end

  it 'should enable the redmine service' do
    expect(chef_run).to enable_service('redmine')
  end

  it 'should start the redmine service' do
    expect(chef_run).to start_service('redmine')
  end

end
