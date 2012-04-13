require 'spec_helper'

describe BnetScraper::Starcraft2::Status do
  describe 'Each supported region' do
    it 'should be online' do
      BnetScraper::Starcraft2::Status.na.should == 'Online'
      BnetScraper::Starcraft2::Status.eu.should == 'Online'
      BnetScraper::Starcraft2::Status.sea.should == 'Online'
      BnetScraper::Starcraft2::Status.fea.should == 'Online'
    end
  end

  describe 'China' do
    BnetScraper::Starcraft2::Status.cn.should == nil
  end
end
