require 'spec_helper'

describe BnetScraper::Starcraft2::MatchHistoryScraper do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches' }
  subject { BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url) }

  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::MatchHistoryScraper }
    let(:scraper) { scraper_class.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches') }
  end

  describe '#scrape' do

    before do
      VCR.use_cassette('demon_matches') do
        subject.scrape
      end
    end
    
    its(:matches) { should have(25).matches }

    it 'should set the name of the map for each match' do
      subject.matches[0][:map_name].should == 'Cloud Kingdom LE'
    end

    it 'should set the type of the match for each match' do
      subject.matches[0][:type].should == '1v1'
    end

    it 'should set the outcome of each match' do
      subject.matches[0][:outcome].should == :win
    end

    it 'should set the match date of each match' do
      subject.matches[0][:date].should == '2/20/2013'
    end

    it 'should raised InvalidProfileError when response is 404' do
      VCR.use_cassette('invalid_matches') do
        url = 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/matches'
        scraper = BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url)
        expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
      end
    end
  end

  describe '#output' do
    before do
      VCR.use_cassette('demon_matches') do
        subject.scrape
      end
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
