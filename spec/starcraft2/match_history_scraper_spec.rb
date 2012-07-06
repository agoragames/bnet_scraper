require 'spec_helper'

describe BnetScraper::Starcraft2::MatchHistoryScraper do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches' }
  subject { BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url) }

  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::MatchHistoryScraper }
    let(:scraper) { scraper_class.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches') }
  end

  describe '#scrape' do

    before :each do
      subject.scrape
    end

    it 'sets the matches to an array of match data' do
      subject.matches.should have(25).matches
    end

    it 'should set the name of the map for each match' do
      subject.matches[0][:map_name].should == 'Bx Monobattle - Sand Canyon (Fix)'
    end

    it 'should set the type of the match for each match' do
      subject.matches[0][:type].should == 'Custom'
    end

    it 'should set the outcome of each match' do
      subject.matches[0][:outcome].should == :win
    end

    it 'should set the match date of each match' do
      subject.matches[0][:date].should == '3/12/2012'
    end

    it 'should raised InvalidProfileError when response is 404' do
      url = 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/matches'
      scraper = BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url)
      expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
    end
  end

  describe '#output' do
    before :each do
      subject.scrape
    end

    it 'should return a hash of the scraped match data' do
      expected = {
        matches:  subject.matches,
        wins:     subject.wins,
        losses:   subject.losses
      }
      subject.output.should == expected
    end
  end
end
