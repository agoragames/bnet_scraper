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

  it 'sends recent_achievements to achievements hash' do
    VCR.use_cassette('demon_achievements') do
      profile.recent_achievements.should == profile.achievements[:recent]
    end
  end

  it 'sends progress_achievements to achievements hash' do
    VCR.use_cassette('demon_achievements') do
      profile.progress_achievements.should == profile.achievements[:progress]
    end
  end

  it 'sends showcase_achievements to achievements hash' do
    VCR.use_cassette('demon_achievements') do
      profile.showcase_achievements.should == profile.achievements[:showcase]
    end
  end

  it 'retrieves match history when first accessed' do
    VCR.use_cassette('demon_match_history') do
      profile.match_history.should have(25).matches
      profile.match_history.first.should be_instance_of BnetScraper::Starcraft2::Match
    end
  end

  context 'campaign completion' do
    before do
      profile.terran_campaign_completion = :brutal
    end

    it 'accepts a campaign and returns a boolean' do
      profile.completed_campaign(:terran).should be_true
    end

    it 'accepts a campaign and a difficulty' do
      profile.completed_campaign(:terran, :hard).should be_true
    end
  end
end
