module BnetScraper
  module Starcraft2
    class League
      attr_accessor :id, :name, :href, :season, :name, :division, :size, :random, :bnet_id,
        :account

      def initialize options = {}
        options.each_key do |key|
          self.send "#{key}=", options[key]
        end
      end

      def name
        scrape_or_return :@name
      end

      def season
        scrape_or_return :@season
      end

      def division
        scrape_or_return :@division
      end

      def size
        scrape_or_return :@size
      end

      def bnet_id
        scrape_or_return :@bnet_id
      end

      def account
        scrape_or_return :@account
      end

      def scrape_or_return attribute
        if self.instance_variable_get(attribute)
          return self.instance_variable_get(attribute)
        else
          scrape_league
          self.instance_variable_get(attribute)
        end
      end

      def scrape_league
        scraper = LeagueScraper.new(url: href)
        scraper.scrape
        scraped_data = scraper.output
        scraped_data.each_key do |key|
          self.send "#{key}=", scraped_data[key]
        end
      end
    end
  end
end
