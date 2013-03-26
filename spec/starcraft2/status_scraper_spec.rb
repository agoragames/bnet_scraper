require 'spec_helper'

describe BnetScraper::Starcraft2::Status do
  describe 'Each supported region' do
    it 'shows its status' do
      VCR.use_cassette('realm_status') do
        BnetScraper::Starcraft2::Status.na.should == 'Online'
        BnetScraper::Starcraft2::Status.eu.should == 'Offline'
        BnetScraper::Starcraft2::Status.sea.should == 'Online'
        BnetScraper::Starcraft2::Status.fea.should == 'Online'
      end
    end
  end


  describe 'China' do
    it 'returns nil' do
      VCR.use_cassette('realm_status') do
        BnetScraper::Starcraft2::Status.cn.should == nil
      end
    end
  end
end
