module BnetScraper
  module Starcraft2
    # MatchHistoryScraper
    # 
    # Scrapes the 25 most recent matches played by an account and returns it
    # as an array of match hashes. 
    class MatchHistoryScraper < BaseScraper
      attr_reader :matches, :wins, :losses, :response
      
      def match_url
        profile_url + "matches"
      end

      def get_response
        @response = Nokogiri::HTML(open(match_url))
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
