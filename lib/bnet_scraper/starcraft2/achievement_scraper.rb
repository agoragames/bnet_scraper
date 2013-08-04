require 'bnet_scraper/starcraft2/achievement'
require 'date'

module BnetScraper
  module Starcraft2
    # This pulls achievement information for an account.  Note that currently only returns the overall achievements,
    # not the in-depth, by-category achievement information.
    #
    # ``` ruby
    # scraper = BnetScraper::Starcraft2::AchievementScraper.new(
    #     url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/'
    # )
    # achievement_information = scraper.scrape
    # achievement_information[:recent].size # => 6
    # achievement_information[:recent].first
    # # => #<BnetScraper::Starcraft2::Achievement:0x007fef52b0b488
    # @description="Win 50 Team Unranked or Ranked games as Zerg.",
    #   @earned=#<Date: 2013-04-04 ((2456387j,0s,0n),+0s,2299161j)>,
    #   @title="50 Wins: Team Zerg">
    #
    # achievement_information[:progress]
    # # => {:liberty_campaign=>1580,
    # :swarm_campaign=>1120,
    #   :matchmaking=>1410,
    #   :custom_game=>120,
    #   :arcade=>220,
    #   :exploration=>530}
    #
    # achievement_information[:showcase].size # => 5
    # achievement_information[:showcase].first
    # # => #<BnetScraper::Starcraft2::Achievement:0x007fef52abcb08
    # @description="Finish a Qualification Round with an undefeated record.",
    #   @title="Hot Shot">
    # ```
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
            earned: convert_date(response.css(".recent-tile")[num].css('span')[1].inner_text)
          })
        end
      end

      def convert_date date
        dates = date.scan(/(\d+)\/(\d+)\/(\d+)/).first.map(&:to_i)
        
        if region == 'na'
          month, day, year = dates
        else
          day, month, year = dates
        end
          
        Date.new year, month, day
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
          if !achievement.values.first.split.include? 'empty'
            Achievement.new({
              title: achievement.css('.tooltip-title').inner_text.strip,
              description: achievement.children[3].children[2].inner_text.strip
            })
          end
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
