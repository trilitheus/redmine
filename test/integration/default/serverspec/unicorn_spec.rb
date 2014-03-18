require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'redmine' do

  it 'has an enabled service of redmine' do
    expect(service('redmine')).to be_running
  end

end
