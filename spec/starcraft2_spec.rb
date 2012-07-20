require 'spec_helper'

describe BnetScraper::Starcraft2 do
  describe '#full_profile_scrape' do
    it 'should return the fully scraped profile with league data' do
      expected = {
        :bnet_id=>"2377239", 
        :account=>"Demon", 
        :bnet_index=>1, 
        :race=>"Protoss", 
        :wins=>"684", 
        :achievement_points=>"3630", 
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
