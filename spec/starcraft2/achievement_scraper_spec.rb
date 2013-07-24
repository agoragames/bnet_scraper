require 'spec_helper'

describe BnetScraper::Starcraft2::AchievementScraper do
  let(:url) { 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/achievements/' }
  let(:scraper) { BnetScraper::Starcraft2::AchievementScraper.new(url: url) }
  subject { scraper }

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
          scraper.get_response
        end
      end

      describe 'showcase' do
        before do
          scraper.scrape_showcase
        end

        its(:showcase) { should have(5).achievements }

        context 'each achievement' do
          subject { scraper.showcase[0] }
          its(:title) { should == 'Hot Shot' }
        end
      end

      describe 'recent' do
        before { scraper.scrape_recent }
        its(:recent) { should have(9).achievements }

        context 'each achievement' do
          subject { scraper.recent[0] }

          it { should be_a BnetScraper::Starcraft2::Achievement }
          its(:title) { should == 'Three-way Dominant' }
          its(:description) { should be_a String }
          its(:earned) { should == Date.new(2013, 2, 7) }
        end

        context 'region-centric date parsing' do
          it 'should parse m/d/y dates of achievements for non-American profiles' do
            scraper = BnetScraper::Starcraft2::AchievementScraper.new(url: 'http://eu.battle.net/sc2/en/profile/1229243/1/Stephano/achievements/')
            VCR.use_cassette('euro_achievements') do
              scraper.scrape
            end

            achivement = scraper.recent[0]
            achievement.earned.should == Date.new(2013, 2, 20)
          end
        end
      end

      describe 'progress' do
        before { scraper.scrape_progress }

        it 'should set the liberty campaign progress' do
          scraper.progress[:liberty_campaign].should == 1580
        end

        it 'should set the swarm campaign progress' do
          scraper.progress[:swarm_campaign].should == 0
        end

        it 'should set the matchmaking progress' do
          subject.progress[:matchmaking].should == 1280
        end

        it 'should set the custom game progress' do
          subject.progress[:custom_game].should == 120
        end

        it 'should set the arcade progress' do
          subject.progress[:arcade].should == 220
        end

        it 'should set the exploration progress' do
          subject.progress[:exploration].should == 480
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
