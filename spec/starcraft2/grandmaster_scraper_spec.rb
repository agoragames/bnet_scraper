require 'spec_helper'

describe BnetScraper::Starcraft2::GrandmasterScraper do
  describe '#scrape' do
    let(:scraper) { BnetScraper::Starcraft2::GrandmasterScraper.new(region: :us) }
    subject  { scraper }
    before do
      VCR.use_cassette('grandmaster_na', record: :new_episodes) do
        scraper.scrape
      end
    end
    it { should have_at_most(200).players }

    context 'player statistics' do
      let(:player) { scraper.players[0] }

      it 'should have rank 1' do
        player[:rank].should == '1st'
      end

      it 'should have a race' do
        player[:race].should == 'protoss'
      end

      it 'should have a name' do
        player[:name].should == 'Aiur'
      end

      it 'should have points' do
        player[:points].should == '2045'
      end

      it 'should have wins' do
        player[:wins].should == '137'
      end

      it 'should have losses' do
        player[:losses].should == '61'
      end
    end
  end
end
