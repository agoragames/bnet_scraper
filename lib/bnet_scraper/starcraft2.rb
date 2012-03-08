module BnetScraper
  module Starcraft2
    REGIONS = {
      'na'  => { domain: 'us.battle.net', dir: 'en' },
      'eu'  => { domain: 'eu.battle.net', dir: 'eu' },
      'cn'  => { domain: 'www.battlenet.com.cn', dir: 'zh' },
      'sea' => { domain: 'sea.battle.net', dir: 'en' },
      'fea' => { domain: 'tw.battle.net', dir: 'zh' } 
    }

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
        @response = @agent.get(profile_url)

        @race = @response.search("#season-snapshot .module-footer a").first().inner_html()
        @wins = @response.search("#career-stats h2").inner_html()
        @achievements = @response.search("#profile-header h3").inner_html()

        parse_response
      end

      def parse_response
         {
          bnet_id: @bnet_id,
          account: @account,
          bnet_index: @bnet_index,
          race: @race,
          wins: @wins,
          achievements: @achievements 
        }  
      end

      def profile_url bnet_index = @bnet_index
        "http://#{region_info[:domain]}/sc2/#{region_info[:dir]}/profile/#{bnet_id}/#{bnet_index}/#{account}/"
      end

      def get_bnet_index
        unless @bnet_index
          [1,2].each do |idx|
                        
          end
        end
      end

      def region_info
        REGIONS[region] 
      end
    end

    class LeagueScraper
      attr_reader :url

      def initialize(url)
        @url = url 
      end
    end
  end
end
