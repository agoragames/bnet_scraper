require 'spec_helper'

describe BnetScraper::Starcraft2::AchievementScraper do
  describe '#initialize' do
    context 'with url parameter passed' do
      subject { BnetScraper::Starcraft2::AchievementScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/achievements/') }

      it 'should extract bnet_id from the URL' do
        subject.bnet_id.should == '2377239' 
      end

      it 'should extract account from the URL' do
        subject.account.should == 'Demon'
      end

      it 'should extract the bnet_index from the URL' do
        subject.bnet_index.should == '1'
      end

      it 'should extract the region from the URL' do
        subject.region.should == 'na'
      end
    end

    context 'when bnet_id and account parameters are passed' do
      subject { BnetScraper::Starcraft2::AchievementScraper.new(bnet_id: '2377239', account: 'Demon') }
      it 'should set the bnet_id and account parameters' do
        subject.bnet_id.should == '2377239'
        subject.account.should == 'Demon'
      end

      it 'should default the region to na' do
        subject.region.should == 'na'
      end

      it 'should assign region if passed' do
        BnetScraper::Starcraft2::AchievementScraper.any_instance.should_receive(:set_bnet_index)
        scraper = BnetScraper::Starcraft2::AchievementScraper.new(bnet_id: '2377239', account: 'Demon', region: 'fea')
        scraper.region.should == 'fea'
      end

      it 'should not call set_bnet_index if bnet_index is passed' do
        BnetScraper::Starcraft2::AchievementScraper.any_instance.should_not_receive(:set_bnet_index)
        scraper = BnetScraper::Starcraft2::AchievementScraper.new(bnet_id: '2377239', account: 'Demon', region: 'fea', bnet_index: '1')
      end

      it 'should call set_bnet_index_if bnet_index is not passed' do
        BnetScraper::Starcraft2::AchievementScraper.any_instance.should_receive(:set_bnet_index)
        scraper = BnetScraper::Starcraft2::AchievementScraper.new(bnet_id: '2377239', account: 'Demon', region: 'fea')
      end
    end
  end

  describe '#scrape' do
    subject { BnetScraper::Starcraft2::AchievementScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/achievements/') }
    before :each do
      subject.scrape
    end

    it 'should set the showcase' do
      subject.showcase.should have(5).achievements
    end

    it 'should set the recently earned' do
      subject.recent.should have(6).achievements
    end

    it 'should set the liberty campaign progress' do
      subject.progress[:liberty_campaign].should == '1580'
    end

    it 'should set the exploration progress' do
      subject.progress[:exploration].should == '480'
    end

    it 'should set the custom game progress' do
      subject.progress[:custom_game].should == '330'
    end

    it 'should set the cooperative progress' do
      subject.progress[:cooperative].should == '660'
    end

    it 'should set the quick match progress' do
      subject.progress[:quick_match].should == '170'
    end
  end
end
