module BnetScraper
  module Starcraft2
    class ProfileScraper
      attr_reader :bnet_id, :account, :region, :agent, :bnet_index

      def initialize bnet_id, account, region = 'na'
        @bnet_id  = bnet_id
        @account  = account
        @region   = region
        @agent    = Mechanize.new
        set_bnet_index
      end

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
        response = @agent.get(profile_url)

        @race = response.search("#season-snapshot .module-footer a").first().inner_html()
        @wins = response.search("#career-stats h2").inner_html()
        @achievements = response.search("#profile-header h3").inner_html()
      end

      def get_league_list
        response = @agent.get(profile_url + "ladder/leagues")

        @leagues = response.search("a[href*='#current-rank']").map do |league|
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
