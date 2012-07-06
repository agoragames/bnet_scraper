module BnetScraper
  module Starcraft2
    # This pulls information on a specific league for a specific account.  It is best used either in conjunction with a
    # profile scrape that profiles a URL, or if you happen to know the specific league\_id and can pass it as an option.
    #
    #  scraper = BnetScraper::Starcraft2::LeagueScraper.new(league_id: '12345', account: 'Demon', bnet_id: '2377239')
    #  scraper.scrape
    #  # => {
    #    season: '6',
    #    name: 'Aleksander Pepper',
    #    division: 'Diamond',
    #    size: '4v4',
    #    random: false,
    #    bnet_id: '2377239',
    #    account: 'Demon'
    #  }
    class LeagueScraper < BaseScraper
      attr_reader :league_id, :season, :size, :random, :name, :division

      # @param [String] url - The league URL on battle.net
      # @return [Hash] league_data - Hash of data extracted
      def initialize options = {}
        super(options)

        if options[:url]
          @league_id = options[:url].match(/http:\/\/.+\/sc2\/.+\/profile\/.+\/\d{1}\/.+\/ladder\/(.+)(#current-rank)?/).to_a[1]
        else
          @league_id = options[:league_id]
        end
      end

      def scrape
        @response = Faraday.get @url
        if @response.success?
          @response = Nokogiri::HTML(@response.body)
          value = @response.css(".data-title .data-label h3").inner_text().strip 
          header_regex = /Season (\d{1}) - \s+(\dv\d)( Random)? (\w+)\s+Division (.+)/
          header_values = value.match(header_regex).to_a
          header_values.shift()
          @season, @size, @random, @division, @name = header_values
          
          @random = !@random.nil?
          output
        end
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
