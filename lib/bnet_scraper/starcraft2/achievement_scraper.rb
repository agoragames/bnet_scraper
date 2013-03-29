require 'bnet_scraper/starcraft2/achievement'

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
    #      swarm_campaign: '480',
    #      matchmaking: '1100',
    #      custom_game: '330',
    #      arcade: '660',
    #      exploration: '170'
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
      #
      # @return [Nokogiri::HTML] The parsed HTML document
      def get_response
        response = Faraday.get "#{profile_url}achievements/"
        if response.success?
          @response = Nokogiri::HTML(response.body) 
        else
          raise BnetScraper::InvalidProfileError
        end
      end

      # scrapes the recent achievements from the account's achievements overview page
      #
      # @return [Array<Achievement>] Array of recent achievements
      def scrape_recent
        @recent = []
        response.css(".recent-tile").size.times do |num|
          achievement = extract_recent_achievement num
          @recent.push(achievement) if achievement
        end

        @recent
      end

      # Scrapes recent achievement by position in the sidebar
      #
      # @param [Fixnum] achievement position number, top-down
      # @return [Achievement] achievement object containing all achievement information
      def extract_recent_achievement num
        if div = response.css("#achv-recent-#{num}")
          Achievement.new({
            title: div.children[1].inner_text,
            description: div.children[2].inner_text.strip,
            earned: response.css(".recent-tile")[num].css('span')[1].inner_text
          })
        end
      end



      # Scrapes the progress of each achievement category from the account's achievements
      # overview page and returns them as a hash
      #
      # @return [Hash] Hash of achievement indicators broken down by category
      def scrape_progress
        keys = [:liberty_campaign, :swarm_campaign, :matchmaking, :custom_game, :arcade, :exploration]
        index = 1

        @progress = keys.inject({}) do |hash, key|
          hash[key] = response.css(".progress-tile:nth-child(#{index}) .profile-progress span").inner_text.to_i
          index += 1

          hash
        end
      end

      # Scrapes the showcase achievements from the account's achievements overview page
      #
      # @return [Array<Achievement>] Array containing all the showcased achievements
      def scrape_showcase
        @showcase = response.css("#showcase-module .progress-tile").map do |achievement|
          Achievement.new({
            title: achievement.css('.tooltip-title').inner_text.strip,
            description: achievement.children[3].children[2].inner_text.strip
          })
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
