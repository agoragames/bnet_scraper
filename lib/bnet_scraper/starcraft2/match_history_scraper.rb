require 'bnet_scraper/starcraft2/match'

module BnetScraper
  module Starcraft2
    # This pulls the 25 most recent matches played for an account. Note that this is only as up-to-date as battle.net is, and
    # will likely not be as fast as in-game.
    #
    #   scraper = BnetScraper::Starcraft2::MatchHistoryScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/')
    #   scraper.scrape
    #   # => {
    #     wins: '15',
    #     losses: '10',
    #     matches: [
    #       { map_name: 'Bx Monobattle - Sand Canyon (Fix)', outcome: :win, type: 'Custom', date: '3/12/2012' },
    #       { map_name: 'Deadlock Ridge', outcome: :loss, type: '4v4', date: '3/12/2012' },
    #       { map_name: 'District 10', outcome: :win, type: '4v4', date: '3/12/2012' },
    #       # ...
    #     ]
    #   }
    class MatchHistoryScraper < BaseScraper
      attr_reader :matches, :response

      # account's match history URL
      def match_url
        profile_url + "matches"
      end

      # retrieves the match history HTML for scraping
      def get_response
        @response = Faraday.get match_url

        if @response.success?
          @response = Nokogiri::HTML(@response.body)
        else
          raise BnetScraper::InvalidProfileError
        end
      end

      def scrape
        get_response
        @matches = []

        response.css('.match-row').each do |m|
          @matches.push extract_match_info m
        end

        @matches
      end

      def wins
        @wins ||= @matches.count { |m| m.outcome == :win }
      end

      def losses
        @losses ||= @matches.count { |m| m.outcome == :loss }
      end

      def extract_match_info m
        match = Match.new

        cells = m.css('td')
        match.map_name = cells[1].inner_text
        match.type = cells[2].inner_text
        match.outcome = (cells.css('.match-win')[0] ? :win : :loss)
        match.date = cells[4].inner_text.strip

        match
      end
    end
  end
end
