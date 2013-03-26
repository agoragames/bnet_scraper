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
      attr_reader :bnet_id, :account, :region, :bnet_index, :url

      def initialize options = {}
        if options[:url]
          extract_data_from_url options[:url]
        elsif options[:bnet_id] && options[:account]
          extract_data_from_options options
        end
      end

      # Extracts information about the account from the URL string
      #
      # @param [String] url of the Battle.net profile page
      def extract_data_from_url url
        extracted_data = url.match(/http:\/\/(.+)\/sc2\/(.+)\/profile\/(.+)\/(\d{1})\/(.[^\/]+)\//)
        if extracted_data
          @region     = REGION_DOMAINS[extracted_data[1]]
          @language   = extracted_data[2]
          @bnet_id    = extracted_data[3]
          @bnet_index = extracted_data[4]
          @account    = extracted_data[5]
          @url        = url
        else
          raise BnetScraper::InvalidProfileError, "URL provided does not match Battle.net format"
        end
      end

      # Extracts information about the account from an options hash
      #
      # @param [Hash] hash of Battle.net account infomation
      def extract_data_from_options options
        @bnet_id  = options[:bnet_id]
        @account  = options[:account]
        @region   = options[:region] || 'na'

        if options[:bnet_index]
          @bnet_index = options[:bnet_index]
        else
          set_bnet_index
        end
      end

      # set_bnet_index
      # 
      # Because profile URLs have to have a specific bnet_index that is seemingly incalculable,
      # we must ping both variants to determine the correct bnet_index. We then store that value.
      def set_bnet_index
        [1,2].each do |idx|
          res = Net::HTTP.get_response URI profile_url idx 
          if res.is_a? Net::HTTPSuccess
            @bnet_index = idx
            return
          end
        end
      end

      def profile_url bnet_index = @bnet_index
        "http://#{region_info[:domain]}/sc2/#{region_info[:dir]}/profile/#{bnet_id}/#{bnet_index}/#{account}/"
      end

      # converts region short-code to region-based URL information
      #   'na' => { domain: 'us.battle.net', :dir: 'en' }
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
