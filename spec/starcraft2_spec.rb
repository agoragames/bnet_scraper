require 'spec_helper'

describe BnetScraper::Starcraft2 do
  describe '#full_profile_scrape' do
    subject do
      VCR.use_cassette('full_demon_scrape') do
        BnetScraper::Starcraft2.full_profile_scrape('2377239', 'Demon')
      end
    end

    it { should be_instance_of BnetScraper::Starcraft2::Profile }
    its(:leagues) { should have(8).leagues }
    its(:achievements) { should have_key :progress }
    its(:achievements) { should have_key :showcase }
    its(:achievements) { should have_key :recent }
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
