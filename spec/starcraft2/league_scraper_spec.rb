require 'spec_helper'

describe BnetScraper::Starcraft2::LeagueScraper do
  let(:url) { "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/155488" }
  subject { BnetScraper::Starcraft2::LeagueScraper.new(url: url) }

  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::LeagueScraper }
    let(:subject) { scraper_class.new(url: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/155488") }
  end

  describe '#initialize' do
    it 'should dissect the league_id from the URL' do
      subject.league_id.should == '155488'
    end
    it 'should determine the URL if it is not present' do
      scraper = BnetScraper::Starcraft2::LeagueScraper.new({
        account: 'Demon', bnet_id: '2377239', league_id: '155488', bnet_index: 1
      })

      scraper.url.should == "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/155488"
    end
  end

  describe '#scrape' do
    context 'valid profile' do
      before do
        VCR.use_cassette('demon_leagues') do
          subject.scrape
        end
      end

      its(:season) {
        should == '2013 Season 4'
      }
      its(:name) { should == 'Dropship Victor' }
      its(:division) { should == 'Silver' }
      its(:size) { should == '2v2' }
      its(:rank) { should == 62 }
      its(:random) { should be_true }
    end

    context 'invalid profile' do
      it 'should raise InvalidProfileError' do
        VCR.use_cassette('invalid_leagues') do
          url = 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/leagues/12345'
          scraper = BnetScraper::Starcraft2::LeagueScraper.new(url: url)
          expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
        end
      end
    end
  end
end
