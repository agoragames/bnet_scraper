module BnetScraper
  module Starcraft2
    # This pulls achievement information for an account.  Note that currently only returns the overall achievements,
    # not the in-depth, by-category achievement information.
    #
    #  scraper = BnetScraper::Starcraft2::AchievementScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/')
    #  scraper.scrape
    #  # => {
    #    recent: [
    #      { title: 'Blink of an Eye', description: 'Complete round 24 in "Starcraft Master" without losing any stalkers', earned: '3/5/2012' },
    #      { title: 'Whack-a-Roach', description: 'Complete round 9 in "Starcraft Master" in under 45 seconds', earned: '3/5/2012' },
    #      { title: 'Safe Zone', description: 'Complete round 8 in "Starcraft Master" without losing any stalkers', earned: '3/5/2012' },
    #      { title: 'Starcraft Master', description: 'Complete all 30 rounds in "Starcraft Master"', earned: '3/5/2012' },
    #      { title: 'Starcraft Expert', description: 'Complete any 25 rounds in "Starcraft Master"', earned: '3/5/2012' },
    #      { title: 'Starcraft Apprentice', description: 'Complete any 20 rounds in "Starcraft Master"', earned: '3/5/2012' }
    #    ],
    #    showcase: [
    #      { title: 'Hot Shot', description: 'Finish a Qualification Round with an undefeated record.' },
    #      { title: 'Starcraft Master', description: 'Complete all rounds in "Starcraft Master"' },
    #      { title: 'Team Protoss 500', description: 'Win 500 team league matches as Protoss' },
    #      { title: 'Night of the Living III', description: 'Survive 15 Infested Horde Attacks in the "Night 2 Die" mode of the "Left 2 Die" scenario.' },
    #      { title: 'Team Top 100 Diamond', description: 'Finish a Season in Team Diamond Division' }
    #                          
    #    ],
    #    progress: {
    #      liberty_campaign: '1580',
    #      exploration: '480',
    #      custom_game: '330',
    #      cooperative: '660',
    #      quick_match: '170'
    #    }
    #  }
    class AchievementScraper < BaseScraper
      attr_reader :recent, :progress, :showcase, :response

      def scrape
        get_response
        scrape_recent
        scrape_progress
        scrape_showcase
        output
      end

      # retrieves the account's achievements overview page HTML for scraping
      def get_response
        response = Faraday.get "#{profile_url}achievements/"
        if response.success?
          @response = Nokogiri::HTML(response.body) 
        else
          raise BnetScraper::InvalidProfileError
        end
      end

      # scrapes the recent achievements from the account's achievements overview page
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

      # scrapes the progress of each achievement category from the account's achievements overview page
      def scrape_progress
        progress_ach = response.css("#progress-module .achievements-progress:nth(2) span")
        @progress = {
          liberty_campaign: response.css(".progress-tile:nth-child(1) .profile-progress span").inner_text,
          exploration:      response.css(".progress-tile:nth-child(2) .profile-progress span").inner_text,
          custom_game:      response.css(".progress-tile:nth-child(3) .profile-progress span").inner_text,
          cooperative:      response.css(".progress-tile:nth-child(4) .profile-progress span").inner_text,
          quick_match:      response.css(".progress-tile:nth-child(5) .profile-progress span").inner_text,
        }
      end

      # scrapes the showcase achievements from the account's achievements overview page
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
