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
      attr_reader :matches, :wins, :losses, :response
       
      # account's match history URL
      def match_url
        profile_url + "matches"
      end

      # retrieves the match history HTML for scraping
      def get_response
        @response = Faraday.get match_url
        
        if @response.success?
          @response = Nokogiri::HTML(@response.body)
        end
      end

      def scrape
        get_response
        @matches = []
        @wins = 0
        @losses = 0

        response.css('.match-row').each do |m|
          match = {}

          cells = m.css('td')
          match[:map_name] = cells[1].inner_text
          match[:type] = cells[2].inner_text
          match[:outcome] = (cells[3].inner_text.strip == 'Win' ? :win : :loss)
          match[:date] = cells[4].inner_text.strip
          @matches << match 
          if match[:outcome] == :win
            @wins += 1
          else
            @losses += 1
          end
          output
        end

      end

      def output
        {
          matches:  @matches,
          wins:     @wins,
          losses:   @losses 
        }
      end
    end
  end
end
