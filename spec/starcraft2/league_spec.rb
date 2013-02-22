require 'spec_helper'

describe BnetScraper::Starcraft2::League do
  let(:href) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/134659' }
  let(:league) { BnetScraper::Starcraft2::League.new href: href }
  subject { league }

  it 'scrapes if name is not set' do
    VCR.use_cassette('demon_leagues') do
      league.name.should == 'Kalathi Echo'
    end
  end

  it 'scrapes if season is not set' do
    VCR.use_cassette('demon_leagues') do
      league.season.should == '2013 Season 1'
    end
  end

  it 'scrapes if division is not set' do
    VCR.use_cassette('demon_leagues') do
      league.division.should == 'Platinum'
    end
  end

  it 'scrapes if size is not set' do
    VCR.use_cassette('demon_leagues') do
      league.size.should == '1v1'
    end
  end

  it 'scrapes if bnet_id is not set' do
    VCR.use_cassette('demon_leagues') do
      league.bnet_id.should == '2377239'
    end
  end

  it 'scrapes if account is not set' do
    VCR.use_cassette('demon_leagues') do
      league.account.should == 'Demon'
    end
  end
end
