require 'spec_helper'

describe BnetScraper::Starcraft2::ProfileScraper do
  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::BaseScraper }
    let(:subject) { scraper_class.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/') }
  end

  subject { BnetScraper::Starcraft2::ProfileScraper.new(bnet_id: '2377239', account: 'Demon') }

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
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96905#current-rank"
          },
          {
            name: "2v2 Random Platinum ...",
            id:   "96716",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96716#current-rank"
          },
          {
            name: "2v2 Diamond Rank 45",
            id:   "98162",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98162#current-rank"
          },
          {
            name: "2v2 Silver Rank 8",
            id:   "97369",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/97369#current-rank"
          },
          {
            name: "3v3 Random Gold Rank...",
            id:   "96828",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96828#current-rank"
          },
          {
            name: "3v3 Diamond Rank 56",
            id:   "97985",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/97985#current-rank"
          },
          {
            name: "3v3 Silver Rank 5",
            id:   "98523",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98523#current-rank"
          },
          {
            name: "3v3 Platinum Rank 88",
            id:   "96863",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96863#current-rank"
          },
          {
            name: "3v3 Gold Rank 75",
            id:   "97250",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/97250#current-rank"
          },
          {
            name: "4v4 Random Platinum ...",
            id:   "96830",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96830#current-rank"
          },
          {
            name: "4v4 Gold Rank 38",
            id:   "98336",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98336#current-rank"
          },
          {
            name: "4v4 Diamond Rank 54",
            id:   "98936",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98936#current-rank"
          }
        ]
      }

      subject.output.should == { bnet_id: '2377239', account: 'Demon', bnet_index: 1, race: nil, wins: nil, achievements: nil, leagues: nil }
      subject.scrape
      subject.output.should == expected
    end
  end
end
