module BnetScraper
  module Starcraft2
    # BaseScraper handles the account information extraction. Each scraper can either be passed a profile URL or
    # the minimum information needed to access an account.  This means passing in account and bnet_id at minimum.
    # Both of the following are valid ways to instantiate a scraper for the same account:
    #
    #   BnetScraper::Starcraft2::BaseScraper.new(url: 'http://us.battle.net/sc2/en/profile/12345/1/TestAccount/')
    #   BnetScraper::Starcraft2::BaseScraper.new(bnet_id: '12345', account: 'TestAccount')
    #
    # The URL scheme is the following:
    #
    #   http://<REGION_DOMAIN>/sc2/<REGION_LANG>/profile/<BNET_ID>/<BNET_INDEX>/<ACCOUNT>/
    #
    # Note that by default, the region will be set to 'na' if you opt not to specify the URL or region.  The 
    # scraper uses the short-codes for regions. See `BnetScraper::Starcraft2::REGIONS` for the address 
    # translations.
    class BaseScraper
      attr_reader :bnet_id, :account, :region, :subregion, :url

      def initialize options = {}
        if options[:url]
          extracted_data = options[:url].match(/http:\/\/(.+)\/sc2\/(.+)\/profile\/(.+)\/(\d{1})\/(.[^\/]+)\//)
          if extracted_data
            @subregion  = extracted_data[4].to_i
            @region     = REGION_DOMAINS[[extracted_data[1], @subregion]]
            @bnet_id    = extracted_data[3]
            @account    = extracted_data[5]
            @url        = options[:url]
          else
            raise BnetScraper::InvalidProfileError, "URL provided does not match Battle.net format"
          end
        elsif options[:bnet_id] && options[:account]
          @bnet_id  = options[:bnet_id]
          @account  = options[:account]
          @region   = options[:region] || 'na'
          @subregion = options[:subregion] || REGIONS[@region][:subregion]
        end
      end

      def profile_url
        "http://#{region_info[:domain]}/sc2/#{region_info[:lang]}/profile/#{bnet_id}/#{subregion}/#{account}/"
      end

      # converts region short-code to region-based URL information
      #   'na' => { domain: 'us.battle.net', :lang: 'en' }
      def region_info
        REGIONS[region]
      end

      def valid?
        result = Faraday.get profile_url
        result.success?
      end

      def scrape
        raise NotImplementedError, "Abstract method #scrape called."
      end
    end
  end
end
