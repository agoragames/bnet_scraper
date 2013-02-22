require 'spec_helper'

describe BnetScraper::Starcraft2::Profile do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/' }
  let(:profile) { BnetScraper::Starcraft2::Profile.new url: url  }
  subject { profile }

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
    end
  end
end
