require 'spec_helper'

describe BnetScraper::Starcraft2::ProfileScraper do
  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::BaseScraper }
    let(:subject) { scraper_class.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/') }
  end

  subject { BnetScraper::Starcraft2::ProfileScraper.new(bnet_id: '2377239', account: 'Demon') }

  describe '#get_profile_data' do
    before do
      subject.get_profile_data
    end

    its(:race) { should == 'Protoss' }
    its(:achievement_points) { should == '3660' }
    its(:current_solo_league) { should == 'Not Yet Ranked' }
    its(:highest_solo_league) { should == 'Platinum' }
    its(:current_team_league) { should == 'Not Yet Ranked' }
    its(:highest_team_league) { should == 'Diamond' }
    its(:career_games) { should == '1568' }
    its(:games_this_season) { should == '0' }
    its(:most_played) { should == '4v4' }
  end

  describe 'get_league_list' do
    it 'should set an array of leagues' do
      subject.should have(0).leagues
      subject.get_league_list

      subject.should have(12).leagues
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

    it 'should return InvalidProfileError if response is 404' do
      scraper = BnetScraper::Starcraft2::ProfileScraper.new url: 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/'
      expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
    end

    context 'account that has not laddered' do
      let(:scraper) {BnetScraper::Starcraft2::ProfileScraper.new(url: 'http://us.battle.net/sc2/en/profile/3354437/1/ClarkeKent/') }
      before do
        scraper.scrape
      end
      
      it 'should have an empty array of leagues' do
        scraper.leagues.should == []
      end
    end
  end

  describe '#output' do
    it 'should extract profile data from the response' do
      expected = {
        bnet_id: '2377239',
        account: 'Demon',
        bnet_index: 1,
        race: 'Protoss',
        career_games: '1568',
        games_this_season: '0',
        highest_solo_league: 'Platinum',
        current_solo_league: 'Not Yet Ranked',
        highest_team_league: 'Diamond',
        current_team_league: 'Not Yet Ranked',
        most_played: '4v4',
        achievement_points: '3660',
        leagues: [
          {
            name: "1v1 Platinum Rank 95", 
            id: "96905",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96905#current-rank"
          }, 
          {
            name: "2v2 Random Platinum ...", 
            id: "96716",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96716#current-rank"
          },
          {
            name: "2v2 Diamond Rank 45",
            id: "98162",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98162#current-rank"
          }, 
          {
            name: "2v2 Silver Rank 8",
            id: "97369", 
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/97369#current-rank"
          },
          {
            name: "3v3 Random Gold Rank...",
            id: "96828",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96828#current-rank"
          }, 
          {
            name: "3v3 Diamond Rank 56",
            id: "97985",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/97985#current-rank"
          }, 
          {
            name: "3v3 Silver Rank 5",
            id: "98523", 
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98523#current-rank"
          },
          {
            name: "3v3 Platinum Rank 88", 
            id: "96863",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96863#current-rank"
          },
          {
            name: "3v3 Gold Rank 75", 
            id: "97250", 
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/97250#current-rank"
          },
          {
            name: "4v4 Random Platinum ...",
            id: "96830",
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96830#current-rank"
          },
          {
            name: "4v4 Gold Rank 38",
            id: "98336", 
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98336#current-rank"
          },
          {
            name: "4v4 Diamond Rank 54",
            id: "98936", 
            href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/98936#current-rank"
          } 
        ]
      }

      subject.output.should == { 
        bnet_id: '2377239', 
        account: 'Demon',
        bnet_index: 1,
        race: nil,
        career_games: nil,
        games_this_season: nil,
        most_played: nil,
        highest_solo_league: nil, 
        current_solo_league: nil, 
        highest_team_league: nil,
        current_team_league: nil,
        achievement_points: nil, 
        leagues: [] 
      }

      subject.scrape
      subject.output.should == expected
    end
  end
end
