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


  describe '#get_profile_data' do
    it 'should set the race, wins, and achievements attributes' do
      subject.instance_variable_get(:@race).should be_nil
      subject.instance_variable_get(:@achievements).should be_nil
      subject.instance_variable_get(:@wins).should be_nil

      subject.get_profile_data
      
      subject.instance_variable_get(:@race).should == 'Protoss'
      subject.instance_variable_get(:@achievements).should == '3630'
      subject.instance_variable_get(:@wins).should == '684'
    end
  end

  describe 'get_league_list' do
    it 'should set an array of leagues' do
      subject.instance_variable_get(:@leagues).should be_nil
      subject.get_league_list

      subject.instance_variable_get(:@leagues).should have(12).leagues
    end
  end

  describe '#scrape' do
    it 'should call get_profile_data' do
      subject.should_receive(:get_profile_data)
      subject.scrape
    end
    it 'should call get_league_list' do
      subject.should_receive(:get_league_list)
      subject.scrape
    end

    it 'should call output' do
      subject.should_receive(:output)
      subject.scrape
    end
  end

  describe '#output' do
    it 'should extract profile data from the response' do
      expected = {
        bnet_id: '2377239',
        account: 'Demon',
        bnet_index: 1,
        race: 'Protoss',
        wins: '684',
        achievements: '3630',
        leagues: [
          {
            name: "1v1 Platinum Rank 95",
            id:   "96905",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues96905#current-rank"
          },
          {
            name: "2v2 Random Platinum ...",
            id:   "96716",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues96716#current-rank"
          },
          {
            name: "2v2 Diamond Rank 45",
            id:   "98162",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues98162#current-rank"
          },
          {
            name: "2v2 Silver Rank 8",
            id:   "97369",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues97369#current-rank"
          },
          {
            name: "3v3 Random Gold Rank...",
            id:   "96828",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues96828#current-rank"
          },
          {
            name: "3v3 Diamond Rank 56",
            id:   "97985",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues97985#current-rank"
          },
          {
            name: "3v3 Silver Rank 5",
            id:   "98523",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues98523#current-rank"
          },
          {
            name: "3v3 Platinum Rank 88",
            id:   "96863",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues96863#current-rank"
          },
          {
            name: "3v3 Gold Rank 75",
            id:   "97250",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues97250#current-rank"
          },
          {
            name: "4v4 Random Platinum ...",
            id:   "96830",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues96830#current-rank"
          },
          {
            name: "4v4 Gold Rank 38",
            id:   "98336",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues98336#current-rank"
          },
          {
            name: "4v4 Diamond Rank 54",
            id:   "98936",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/leagues98936#current-rank"
          }
        ]
      }

      subject.output.should == { bnet_id: '2377239', account: 'Demon', bnet_index: 1, race: nil, wins: nil, achievements: nil, leagues: nil }
      subject.scrape
      subject.output.should == expected
    end
  end
end
