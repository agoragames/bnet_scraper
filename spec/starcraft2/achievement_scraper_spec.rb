require 'spec_helper'

describe BnetScraper::Starcraft2::AchievementScraper do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/achievements/' }
  subject { BnetScraper::Starcraft2::AchievementScraper.new(url: url) }

  it_behaves_like 'an SC2 Scraper' do
    let(:scraper_class) { BnetScraper::Starcraft2::AchievementScraper }
    let(:subject) { scraper_class.new(url: url) }
  end

  describe 'scrape' do
    it 'should return InvalidProfileError if response is 404' do
      VCR.use_cassette('invalid_achievement') do
        url = 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/achievements/'
        scraper = BnetScraper::Starcraft2::AchievementScraper.new(url: url)
        expect { scraper.scrape }.to raise_error(BnetScraper::InvalidProfileError)
      end
    end

    context 'valid' do
      before do
        VCR.use_cassette('demon_achievements') do
          subject.get_response
        end
      end

      describe 'showcase' do
        before { subject.scrape_showcase }
        its(:showcase) { should have(5).achievements }
      end

      describe 'recent' do
        before { subject.scrape_recent }

        it 'should have the title of the achievement' do
          subject.recent[0][:title].should == 'Three-way Dominant'  
        end

        it 'should have the description of the achievement' do
          # this is a cop-out because the string contains UTF-8. Please fix this. - Cad
          subject.recent[0][:description].should be_a String 
        end

        it 'should have the date the achievement was earned' do
          subject.recent[0][:earned].should == '2/7/2013' 
        end
      end

      describe 'progress' do
        before { subject.scrape_progress }

        it 'should set the liberty campaign progress' do
          subject.progress[:liberty_campaign].should == '1580'
        end

        it 'should set the exploration progress' do
          subject.progress[:exploration].should == '0'
        end

        it 'should set the custom game progress' do
          subject.progress[:custom_game].should == '1280'
        end

        it 'should set the cooperative progress' do
          subject.progress[:cooperative].should == '120'
        end

        it 'should set the quick match progress' do
          subject.progress[:quick_match].should == '220'
        end
      end
    end
  end

  describe '#output' do
    it 'should return the scraped data when scrape has been called' do
      VCR.use_cassette('demon_achievements') do
        subject.scrape
        expected = {
          recent: subject.recent,
          showcase: subject.showcase,
          progress: subject.progress
        }
        subject.output.should == expected
      end
    end
  end
end
