require 'spec_helper'

describe BnetScraper::Starcraft2::LeagueScraper do
  let(:url) { "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/12345" }
  subject { BnetScraper::Starcraft2::LeagueScraper.new(url) }

  describe '#initialize' do
    it 'should take a league URL parameter' do
      subject.url.should == url
    end

    it 'should dissect the bnet_id from the URL' do
      subject.bnet_id.should == '2377239' 
    end

    it 'should dissect the account from the URL' do
      subject.account.should == 'Demon'
    end

    it 'should dissect the league_id from the URL' do
      subject.league_id.should == '12345'
    end

    it 'should dissect the bnet_index from the URL' do
      subject.bnet_index.should == '1'
    end

    it 'should dissect the lang from the URL' do
      subject.lang.should == 'en'
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

    it 'should call parse_response' do
      subject.should_receive(:parse_response)
      subject.scrape
    end
  end

  describe '#parse_response' do
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
      subject.parse_response.should == expected
    end
  end
end
