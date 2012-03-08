require 'spec_helper'

describe BnetScraper::Starcraft2::LeagueScraper do
  describe '#initialize' do
    it 'should take a league URL parameter' do
      url = "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/12345"
      scraper = BnetScraper::Starcraft2::LeagueScraper.new(url)
      scraper.url.should == url
    end
  end
end
