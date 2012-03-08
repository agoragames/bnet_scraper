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
        :achievements=>"3630", 
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
end
