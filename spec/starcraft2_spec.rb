require 'spec_helper'

describe BnetScraper::Starcraft2 do
  describe '#full_profile_scrape' do
    it 'should return the fully scraped profile with league data' do
      VCR.use_cassette('full_demon_scrape') do
        actual = BnetScraper::Starcraft2.full_profile_scrape('2377239', 'Demon')

        actual.should be_instance_of Hash
        actual[:leagues].should have(8).leagues
      end
    end
  end

  describe '#valid_profile?' do
    it 'should return true on valid profile' do
      VCR.use_cassette('demon_profile') do
        result = BnetScraper::Starcraft2.valid_profile? url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/'
        result.should be_true
      end
    end

    it 'should return false on invalid profile' do
      VCR.use_cassette('invalid_profile') do
        result = BnetScraper::Starcraft2.valid_profile? url: 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/'
        result.should be_false
      end
    end
  end
end
