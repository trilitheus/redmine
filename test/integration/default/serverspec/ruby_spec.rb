require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/usr/bin'
  end
end

describe package('ruby1.9.3') do
  it { should be_installed }
end

describe file('/usr/bin/ruby1.9.1') do
  it { should be_executable }
end
