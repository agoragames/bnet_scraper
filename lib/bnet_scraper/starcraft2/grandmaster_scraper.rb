module BnetScraper
  module Starcraft2
    class GrandmasterScraper < BaseScraper
      attr_reader :players
      REGIONS = [:us, :eu, :kr, :tw, :sea]

      def initialize options = {}
        @players = []
        if REGIONS.include? options[:region]
          @url = "https://#{options[:region]}.battle.net/sc2/en/ladder/grandmaster/heart-of-the-swarm"
        else
          raise "Invalid Region #{options[:region]}"
        end
      end

      def scrape
        html = retrieve_data    

        get_grandmasters html

        @players
      end

      def retrieve_data
        response = Faraday.get @url

        if response.success?
          Nokogiri::HTML(response.body)
        end
      end

      def get_grandmasters html
        html.css("#ladder tbody tr").each do |player_data|
          player_cells = player_data.css("td[class='align-center']")
          player = {
            name: player_data.css("td a").inner_text.strip,
            points: player_cells[2].inner_text,
            wins: player_cells[3].inner_text,
            losses: player_cells[4].inner_text,
            race: player_data.css("td a").attr('class').value.sub('race-', ''),
            rank: player_cells[1].inner_text.strip
          }

          @players << player
        end
      end
    end
  end
end
