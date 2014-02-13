require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'nginx' do

  it 'is installed' do
    expect(package('nginx')).to be_installed
  end

  it 'has an enabled service of nginx' do
    expect(service('nginx')).to be_running
  end

  it 'has a running service of nginx' do
    expect(service('nginx')).to be_running
  end

  it 'is listening on port 80' do
    expect(port(80)).to be_listening
  end

end
