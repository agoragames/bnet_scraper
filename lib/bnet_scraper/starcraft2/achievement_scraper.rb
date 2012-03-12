module BnetScraper
  module Starcraft2
    class AchievementScraper
      attr_reader :region, :bnet_id, :account, :bnet_index, :recent, :progress, :showcase, :response
      def initialize options = {}
        if options[:url]
          extracted_data = options[:url].match(/http:\/\/(.+)\/sc2\/(.+)\/profile\/(.+)\/(\d{1})\/(.+)\/achievements\//)
          @region = REGIONS.key({ domain: extracted_data[1], dir: extracted_data[2] })
          @bnet_id = extracted_data[3]
          @bnet_index = extracted_data[4]
          @account = extracted_data[5]
        elsif options[:bnet_id] && options[:account]
          @account = options[:account]
          @bnet_id = options[:bnet_id]
          @region  = options[:region] || 'na'

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
          res = Net::HTTP.get_response URI achievement_url idx 
          if res.is_a? Net::HTTPSuccess
            @bnet_index = idx
            return
          end
        end
      end

      def achievement_url bnet_index = @bnet_index
        "http://#{region_info[:domain]}/sc2/#{region_info[:dir]}/profile/#{bnet_id}/#{bnet_index}/#{account}/achievements/"
      end

      def region_info
        REGIONS[region] 
      end

      def scrape
        get_response
        scrape_recent
        scrape_progress
        scrape_showcase
      end

      def get_response
        @response = Nokogiri::HTML(open(achievement_url)) 
      end

      def scrape_recent
        @recent = []
        6.times do |num|
          achievement = {}
          div = response.css("#achv-recent-#{num}")
          if div
            achievement[:title] = div.css("div > div").inner_text.strip
            achievement[:description] = div.inner_text.gsub(achievement[:title], '').strip
            achievement[:earned] = response.css("#recent-achievements span")[(num*3)+1].inner_text

            @recent << achievement
          end
        end
        @recent
      end

      def scrape_progress
        progress_ach = response.css("#progress-module .achievements-progress:nth(2) span")
        @progress = {
          liberty_campaign: progress_ach[0].inner_text,
          exploration:      progress_ach[1].inner_text,
          custom_game:      progress_ach[2].inner_text,
          cooperative:      progress_ach[3].inner_text,
          quick_match:      progress_ach[4].inner_text,
        }
      end

      def scrape_showcase
        @showcase = response.css("#showcase-module .progress-tile").map do |achievement|
          hsh = { title: achievement.css('.tooltip-title').inner_text.strip }
          hsh[:description] = achievement.css('div').inner_text.gsub(hsh[:title], '').strip
          hsh
        end
        @showcase
      end

      def output
        {
          recent: @recent,
          progress: @progress,
          showcase: @showcase
        }
      end
    end
  end
end
