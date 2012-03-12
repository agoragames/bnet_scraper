shared_examples 'an SC2 Scraper' do
  describe '#initialize' do
    context 'with url parameter passed' do
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
      subject { scraper_class.new(bnet_id: '2377239', account: 'Demon') }
      it 'should set the bnet_id and account parameters' do
        subject.bnet_id.should == '2377239'
        subject.account.should == 'Demon'
      end

      it 'should default the region to na' do
        subject.region.should == 'na'
      end

      it 'should assign region if passed' do
        scraper_class.any_instance.should_receive(:set_bnet_index)
        scraper = scraper_class.new(bnet_id: '2377239', account: 'Demon', region: 'fea')
        scraper.region.should == 'fea'
      end

      it 'should not call set_bnet_index if bnet_index is passed' do
        scraper_class.any_instance.should_not_receive(:set_bnet_index)
        scraper = scraper_class.new(bnet_id: '2377239', account: 'Demon', region: 'fea', bnet_index: '1')
      end

      it 'should call set_bnet_index_if bnet_index is not passed' do
        scraper_class.any_instance.should_receive(:set_bnet_index)
        scraper = scraper_class.new(bnet_id: '2377239', account: 'Demon', region: 'fea')
      end
    end
  end

  describe '#region_info' do
    it 'should return information based on the set region' do
      subject.region_info.should == { domain: 'us.battle.net', dir: 'en' }
    end
  end

  describe '#set_bnet_index' do
    it 'should return the valid integer needed for a proper URL parse from bnet' do
      subject.set_bnet_index 
      subject.bnet_index.should == 1
    end
  end

  describe '#profile_url' do
    it 'should return a string URL for bnet' do
      subject.profile_url.should == 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/'
    end

    it 'should optionally take a bnet_index to use instead of saved bnet_index' do
      subject.profile_url(2).should == 'http://us.battle.net/sc2/en/profile/2377239/2/Demon/'
    end
  end
end
