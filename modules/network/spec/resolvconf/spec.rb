require 'spec_helper'

describe 'network::resolvconf' do

  describe file('/etc/resolv.conf') do
    it { should be_file }
    its(:content) { should match /example\.local/ }
  end

end
