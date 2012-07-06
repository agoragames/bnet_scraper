require 'spec_helper'

describe BnetScraper::Starcraft2::LeagueScraper do
  let(:url) { "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/12345" }
  subject { BnetScraper::Starcraft2::LeagueScraper.new(url: url) }

  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::LeagueScraper }
    let(:subject) { scraper_class.new(url: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/12345") }
  end

  describe '#initialize' do
    it 'should dissect the league_id from the URL' do
      subject.league_id.should == '12345'
    end
  end

  describe '#scrape' do
    it 'should set the season value' do
      subject.season.should be_nil
      subject.scrape
      subject.season.should == '6'
    end

    it 'should set the name' do
      subject.name.should be_nil 
      subject.scrape
      subject.name.should == 'Aleksander Pepper'
    end

    it 'should set the divison' do
      subject.division.should be_nil
      subject.scrape
      subject.division.should == 'Diamond'
    end

    it 'should set the size' do
      subject.size.should be_nil
      subject.scrape
      subject.size.should == '4v4'
    end

    it 'should set if player is random' do
      subject.random.should be_nil
      subject.scrape
      subject.random.should be_false 
    end

    it 'should call output' do
      subject.should_receive(:output)
      subject.scrape
    end

    it 'should raise InvalidProfileError when response is 404' do
      url = 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/leagues/12345' 
      scraper = BnetScraper::Starcraft2::LeagueScraper.new(url: url)
      expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
    end
  end

  describe '#output' do
    it 'should return a hash of league data' do
      expected = {
        season: '6',
        name: 'Aleksander Pepper',
        division: 'Diamond',
        size: '4v4',
        random: false,
        bnet_id: '2377239',
        account: 'Demon'
      }

      subject.scrape
      subject.output.should == expected
    end
  end
end
