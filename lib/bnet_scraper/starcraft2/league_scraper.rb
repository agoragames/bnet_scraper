module BnetScraper
  module Starcraft2
    # LeagueScraper
    #
    # Extracts information from an SC2 League URL and scrapes for information.
    # Example:
    #   league_data = BnetScraper::Starcraft2::LeagueScraper.new("http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96905")
    #   league_data # => { bnet_id: '2377239', account: 'Demon', season: '6', size: '4v4', name: "Aleksander Pepper", division: "Diamond", random: false } 
    #
    # @param [String] url - The league URL on battle.net
    # @return [Hash] league_data - Hash of data extracted
    class LeagueScraper < BaseScraper
      attr_reader :league_id, :season, :size, :random, :name, :division

      def initialize options = {}
        super(options)

        if options[:url]
          @league_id = options[:url].match(/http:\/\/.+\/sc2\/.+\/profile\/.+\/\d{1}\/.+\/ladder\/(.+)(#current-rank)?/).to_a[1]
        else
          @league_id = options[:league_id]
        end
      end

      def scrape
        @response = Nokogiri::HTML(open(@url))
        value = @response.css(".data-title .data-label h3").inner_text().strip 
        header_regex = /Season (\d{1}) - \s+(\dv\d)( Random)? (\w+)\s+Division (.+)/
        header_values = value.match(header_regex).to_a
        header_values.shift()
        @season, @size, @random, @division, @name = header_values
        
        @random = !@random.nil?
        output
      end

      def output
        {
          season: @season,
          size: @size,
          name: @name,
          division: @division,
          random: @random,
          bnet_id: @bnet_id,
          account: @account
        }
      end
    end
  end
end
