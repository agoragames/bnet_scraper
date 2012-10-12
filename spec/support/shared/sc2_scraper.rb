shared_examples 'an SC2 Scraper' do
  describe '#initialize' do
    context 'with url parameter passed' do
      it 'should extract bnet_id from the URL' do
        subject.bnet_id.should == '2377239' 
      end

      it 'should extract account from the URL' do
        subject.account.should == 'Demon'
      end

      it 'should extract the subregion from the URL' do
        subject.subregion.should == 1
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
        scraper = scraper_class.new(bnet_id: '2377239', account: 'Demon', region: 'tw')
        scraper.region.should == 'tw'
      end
    end
  end

  describe '#region_info' do
    it 'should return information based on the set region' do
      subject.region_info.should == { domain: 'us.battle.net', subregion: 1, lang: 'en', label: 'North America' }
    end
  end

  describe '#profile_url' do
    it 'should return a string URL for bnet' do
      subject.profile_url.should == 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/'
    end
  end

  describe '#valid?' do
    it 'should return true when profile is valid' do
      result = subject.valid?
      result.should be_true
    end

    it 'should return false when profile is invalid' do
      scraper = scraper_class.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/SomeDude/')

      result = scraper.valid?
      result.should be_false
    end
  end
end
