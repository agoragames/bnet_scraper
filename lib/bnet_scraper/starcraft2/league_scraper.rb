module BnetScraper
  module Starcraft2
    class LeagueScraper
      attr_reader :url, :bnet_id, :bnet_index, :account, :league_id, :lang,
        :season, :size, :random, :name, :division

      def initialize(url)
        @url, @lang, @bnet_id, @bnet_index, @account, @league_id = url.match(/http:\/\/.+\/sc2\/(.+)\/profile\/(.+)\/(\d{1})\/(.+)\/ladder\/(.+)(#current-rank)?/).to_a
      end

      def scrape
        @response = Nokogiri::HTML(open(@url))
        value = @response.css(".data-title .data-label h3").inner_text().strip 
        header_regex = /Season (\d{1}) - \s+(\dv\d)( Random)? (\w+)\s+Division (.+)/
        header_values = value.match(header_regex).to_a
        header_values.shift()
        @season, @size, @random, @division, @name = header_values
        
        @random = !@random.nil?
        parse_response
      end

      def parse_response
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
