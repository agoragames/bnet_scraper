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
    #
    # ProfileScraper requires that either you pass the URL of the profile, or the bnet_id and
    # account name of the profile.  The URL scheme is as such:
    #
    #   http://<REGION_DOMAIN>/sc2/<REGION_LANG>/profile/<BNET_ID>/<BNET_INDEX>/<ACCOUNT>/
    #
    # Using this URL we can extract the critical information.  However, sometimes we do not have
    # the URL and have to make do with a bnet_id and account.  This is the bare minimum needed,
    # unless the account is in a region other than 'na'.  In such cases, region all needs to be passed.
    class ProfileScraper
      attr_reader :bnet_id, :account, :region, :agent, :bnet_index

      # @param options - Hash of options to parse.
      # @return profile_data - The hash of profile data scraped, including array of leagues to scrape
      def initialize options = {}
        if options[:url]
          extracted_data = options[:url].match(/http:\/\/(.+)\/sc2\/(.+)\/profile\/(.+)\/(\d{1})\/(.+)\//)
          @region = REGIONS.key({ domain: extracted_data[1], dir: extracted_data[2] })
          @bnet_id = extracted_data[3]
          @bnet_index = extracted_data[4]
          @account = extracted_data[5]
        elsif options[:bnet_id] && options[:account]
          @bnet_id  = options[:bnet_id]
          @account  = options[:account]
          @region   = options[:region] || 'na'
          if options[:bnet_index]
            @bnet_index = options[:bnet_index]
          else
            set_bnet_index
          end
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
