require 'bnet_scraper/starcraft2/league'

module BnetScraper
  module Starcraft2
    # This pulls information on a specific league for a specific account.  It is best used either in conjunction with a
    # profile scrape that profiles a URL, or if you happen to know the specific league\_id and can pass it as an option.
    #
    #   ``` ruby
    #   scraper = BnetScraper::Starcraft2::LeagueScraper.new(league_id: '12345', account: 'Demon', bnet_id: '2377239')
    #   scraper.scrape
    #
    #   # => #<BnetScraper::Starcraft2::League:0x007f89eab7a680
    #   @account="Demon",
    #   @bnet_id="2377239",
    #   @division="Bronze",
    #   @name="Changeling Bravo",
    #   @random=false,
    #   @season="2013 Season 4",
    #   @size="3v3">
    #   ```
    class LeagueScraper < BaseScraper
      attr_reader :league_id, :season, :size, :random, :name, :division, :rank

      # @param [String] url - The league URL on battle.net
      # @return [Hash] league_data - Hash of data extracted
      def initialize options = {}
        super(options)

        if options[:url]
          @league_id = options[:url].match(/http:\/\/.+\/sc2\/.+\/profile\/.+\/\d{1}\/.+\/ladder\/(.+)(#current-rank)?/).to_a[1]
        else
          @league_id = options[:league_id]
          @url = "#{profile_url}ladder/#{@league_id}"
        end
      end

      def scrape
        @response = Faraday.get @url
        if @response.success?
          @response = Nokogiri::HTML(@response.body)
          value = @response.css(".data-title .data-label h3").inner_text.strip
          header_regex = /(.+) -\s+(\dv\d)( Random)? (\w+)\s+Division (.+)/
          header_values = value.match(header_regex).to_a
          header_values.shift
          @season, @size, @random, @division, @name = header_values
          @rank = @response.css('.data-table #current-rank td:nth-child(2)').inner_text.gsub(/\D/,'').to_i
          @random = !@random.nil?
          League.new(output)
        else
          raise BnetScraper::InvalidProfileError
        end
      end

      def output
        {
          season: @season,
          size: @size,
          name: @name,
          division: @division,
          rank: @rank,
          random: @random,
          bnet_id: @bnet_id,
          account: @account
        }
      end
    end
  end
end
