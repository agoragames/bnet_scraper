require 'spec_helper'

describe BnetScraper::Starcraft2::ProfileScraper do
  subject { BnetScraper::Starcraft2::ProfileScraper.new('2377239', 'Demon') }

  describe '#initialize' do
    it 'should take bnet_id and account parameters' do
      subject.bnet_id.should == '2377239'
      subject.account.should == 'Demon'
    end

    it 'should default the region to na' do
      subject.region.should == 'na'
    end

    it 'should assign region if passed' do
      BnetScraper::Starcraft2::ProfileScraper.any_instance.should_receive(:set_bnet_index)
      scraper = BnetScraper::Starcraft2::ProfileScraper.new('2377239', 'Demon', 'fea')
      scraper.region.should == 'fea'
    end
  end

  describe '#region_info' do
    it 'should return information based on the set region' do
      subject.region_info.should == { domain: 'us.battle.net', dir: 'en' }
    end
  end

  describe '#set_bnet_index' do
    it 'should return the valid integer needed for a proper URL parse from bnet' do
      subject.set_bnet_index 
      subject.bnet_index.should == 1
    end
  end

  describe '#profile_url' do
    it 'should return a string URL for bnet' do
      subject.profile_url.should == 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/'
    end

    it 'should optionally take a bnet_index to use instead of saved bnet_index' do
      subject.profile_url(2).should == 'http://us.battle.net/sc2/en/profile/2377239/2/Demon/'
    end
  end

  describe '#scrape' do
    it 'should set the race, wins, and achievements attributes' do
      subject.instance_variable_get(:@race).should be_nil
      subject.instance_variable_get(:@achievements).should be_nil
      subject.instance_variable_get(:@wins).should be_nil

      subject.scrape
      
      subject.instance_variable_get(:@race).should == 'Protoss'
      subject.instance_variable_get(:@achievements).should == '3630'
      subject.instance_variable_get(:@wins).should == '684'
    end

    it 'should call parse_response' do
      subject.should_receive(:parse_response)
      subject.scrape
    end
  end

  describe '#parse_response' do
    it 'should extract profile data from the response' do
      expected = {
        bnet_id: '2377239',
        account: 'Demon',
        bnet_index: 1,
        race: 'Protoss',
        wins: '684',
        achievements: '3630'
      }

      subject.parse_response.should == { bnet_id: '2377239', account: 'Demon', bnet_index: 1, race: nil, wins: nil, achievements: nil }
      subject.scrape
      subject.parse_response.should == expected
    end
  end
end
