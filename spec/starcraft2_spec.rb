require 'spec_helper'

describe BnetScraper::Starcraft2 do
  describe '#full_profile_scrape' do
    it 'should return the fully scraped profile with league data' do
      expected = {
        :bnet_id=>"2377239", 
        :account=>"Demon", 
        :bnet_index=>1, 
        :race=>"Protoss", 
        :career_games => '1568',
        :games_this_season => '0',
        :most_played => '4v4',
        :current_solo_league => 'Not Yet Ranked',
        :highest_solo_league => 'Platinum',
        :current_team_league => 'Not Yet Ranked',
        :highest_team_league => 'Diamond',
        :achievement_points=>"3660", 
        :leagues=>[
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"},
          {:season=>"6", :size=>"4v4", :name=>"Aleksander Pepper", :division=>"Diamond", :random=>false, :bnet_id=>"2377239", :account=>"Demon"}
        ]
      }
      actual = BnetScraper::Starcraft2.full_profile_scrape('2377239', 'Demon')
      actual.should == expected
    end
  end

  describe '#valid_profile?' do
    it 'should return true on valid profile' do
      result = BnetScraper::Starcraft2.valid_profile? url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/'
      result.should be_true
    end

    it 'should return false on invalid profile' do
      result = BnetScraper::Starcraft2.valid_profile? url: 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/'
      result.should be_false
    end
  end
end
