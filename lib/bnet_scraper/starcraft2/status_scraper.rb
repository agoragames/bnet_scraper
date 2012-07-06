module BnetScraper
  module Starcraft2
    # Ask the TL.net bot if Battle.Net is currently online for a given region.
    # This page is updated every 5 minutes. Call #fetch to refresh.
    #
    # Examples:
    #   BnetScraper::Starcraft2::Status.na  => 'Online'
    #   BnetScraper::Starcraft2::Status.fea => 'Offline'
    #   BnetScraper::Starcraft2::Status.cn  => nil (China is unsupported)
    #   BnetScraper::Starcraft2::Status.fetch => [
    #     {:region=>"North America", :status=>"Online"},{:region=>"Europe", :status=>"Online"},
    #     {:region=>"Korea", :status=>"Online"}, {:region=>"South-East Asia", :status=>"Online"}
    #   ]
    class Status
      SOURCE = 'http://www.teamliquid.net/forum/viewmessage.php?topic_id=138846'

      class << self

        def fetch
          response = Faraday.get SOURCE
          Nokogiri::HTML(response.body)
            .css('.forumPost').first.css('span').to_a
            .each_slice(2).map { |i| { :region => i.first.text, :status => i.last.text } }
        end

        def method_missing sym
          status? sym if REGIONS.reject { |r| r == 'cn' }.include?(sym.to_s)
        end

        private
        def status? region
          @status ||= fetch
          @status.select do |r|
            r[:region] == REGIONS.select { |k,v| k == region.to_s }.first.last[:label]
          end.first[:status]
        end
      end
    end
  end
end
