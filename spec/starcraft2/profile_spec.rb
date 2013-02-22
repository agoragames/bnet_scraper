require 'spec_helper'

describe BnetScraper::Starcraft2::Profile do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/' }
  let(:profile) { BnetScraper::Starcraft2::Profile.new url: url  }
  subject { profile }

  its(:swarm_levels) { should be_instance_of Hash }
  its(:swarm_levels) { should have_key :zerg }
  its(:swarm_levels) { should have_key :protoss }
  its(:swarm_levels) { should have_key :terran }

  it 'retrieves achievements when first accessed' do
    VCR.use_cassette('demon_achievements') do
      profile.achievements.should have_key(:recent)
      profile.achievements.should have_key(:showcase)
      profile.achievements.should have_key(:progress)
    end
  end

  it 'retrieves match history when first accessed' do
    VCR.use_cassette('demon_match_history') do
      profile.match_history.should have(25).matches
      profile.match_history.first.should be_instance_of BnetScraper::Starcraft2::Match
    end
  end

end
