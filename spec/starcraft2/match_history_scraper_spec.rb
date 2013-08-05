require 'spec_helper'

describe BnetScraper::Starcraft2::MatchHistoryScraper do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches' }
  let(:scraper) { BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url) }
  subject { scraper }

  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::MatchHistoryScraper }
    let(:scraper) { scraper_class.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/matches') }
  end

  describe '#scrape' do

    before do
      VCR.use_cassette('demon_matches') do
        scraper.scrape
      end
    end

    its(:matches) { should have(25).matches }
    its(:wins) { should == 15 }
    its(:losses) { should == 10 }

    describe 'each match' do
      subject { scraper.matches[0] }
      its(:map_name) { should == 'The Bone Trench' }
      its(:type) { should == '2v2' }
      its(:outcome) { should == :win }
      its(:date) { should == '8/2/2013' }
    end

    it 'should raised InvalidProfileError when response is 404' do
      VCR.use_cassette('invalid_matches') do
        url = 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/matches'
        scraper = BnetScraper::Starcraft2::MatchHistoryScraper.new(url: url)
        expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
      end
    end
  end
end
