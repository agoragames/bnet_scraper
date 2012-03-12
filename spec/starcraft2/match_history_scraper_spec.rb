require 'spec_helper'

describe BnetScraper::Starcraft2::MatchHistoryScraper do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches' }
  subject { BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url) }

  it 'should be true' do
    true 
  end
end
