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

  %w{shared
     shared/config
     shared/log
     shared/pids
     shared/system
     shared/files
     shared/vendor
     shared/script
    }.each do |dir|
    it "should create redmine's shared directory #{dir}" do
      expect(chef_run).to create_directory("/srv/redmine/#{dir}").with(user: 'redmine', group: 'redmine')
    end
  end

  %w{config/database.yml
     config/configuration.yml
     config/unicorn.rb
     script/web
    }.each do |file|
    it "should render /srv/redmine/shared/#{file}" do
      expect(chef_run).to render_file("/srv/redmine/shared/#{file}")
    end
  end

end
