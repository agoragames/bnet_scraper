module BnetScraper
  module Starcraft2
    # ProfileScraper
    #
    # Scrapes SC2 profile data from battle.net and returns it as a hash.  Example:
    #   profile_data = BnetScraper::Starcraft2::ProfileScraper.new('2377239', 'Demon')
    #   profile_data # => { bnet_id: '2377239', account: 'Demon', race: 'Protoss', 
    #                       wins: '684', achievements: '3260', leagues: [], bnet_index: 1 }
    #
    # One thing of note is the bnet_index. In Battle.net URLs, there is a single-digit index
    # used on accounts (1 or 2).  This index is seemingly arbitrary, but critical to properly
    # accessing the data.
    class ProfileScraper
      attr_reader :bnet_id, :account, :region, :agent, :bnet_index

      # @param bnet_id - The unique ID for each battle.net account. in the URL scheme, it immediately
      #   follows the /profile/ directive.
      # @param account - The account name.  This is a non-unique string that immediately follows the
      #   bnet_index
      # @oaram region - The region of the account.  This defaults to 'na' for North America. This
      #   uses the bnet region codes instead of the full names. The region is used to determine the
      #   domain to find the profile, as well as teh default language code to use.
      # @return profile_data - The hash of profile data scraped, including array of leagues to scrape
      def initialize bnet_id, account, region = 'na'
        @bnet_id  = bnet_id
        @account  = account
        @region   = region
        set_bnet_index
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

      def scrape
        get_profile_data
        get_league_list
        output
      end

      def get_profile_data
        response = Nokogiri::HTML(open(profile_url))

        @race = response.css("#season-snapshot .module-footer a").first().inner_html()
        @wins = response.css("#career-stats h2").inner_html()
        @achievements = response.css("#profile-header h3").inner_html()
      end

      def get_league_list
        response = Nokogiri::HTML(open(profile_url + "ladder/leagues"))

        @leagues = response.css("a[href*='#current-rank']").map do |league|
          {
            name: league.inner_html().strip,
            id: league.attr('href').sub('#current-rank',''),
            href: "#{profile_url}ladder/#{league.attr('href')}"
          }
        end
      end

      def output
         {
          bnet_id: @bnet_id,
          account: @account,
          bnet_index: @bnet_index,
          race: @race,
          wins: @wins,
          achievements: @achievements,
          leagues: @leagues
        }  
      end

      def profile_url bnet_index = @bnet_index
        "http://#{region_info[:domain]}/sc2/#{region_info[:dir]}/profile/#{bnet_id}/#{bnet_index}/#{account}/"
      end

      def region_info
        REGIONS[region] 
      end
    end
  end
end
