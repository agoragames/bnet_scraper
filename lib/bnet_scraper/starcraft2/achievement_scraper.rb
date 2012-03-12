module BnetScraper
  module Starcraft2
    class AchievementScraper < BaseScraper
      attr_reader :recent, :progress, :showcase, :response

      def scrape
        get_response
        scrape_recent
        scrape_progress
        scrape_showcase
      end

      def get_response
        @response = Nokogiri::HTML(open(profile_url+"achievements/")) 
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
