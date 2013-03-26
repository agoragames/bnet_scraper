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
          servers = Nokogiri::HTML(response.body).css('.forumPost').first.css('span').to_a
          servers.each_slice(2).map do |server_info| 
            { region: server_info[0].text, status: server_info[1].text }
          end
        end

        def method_missing sym
          status? sym if REGIONS.reject { |r| r == 'cn' }.include?(sym.to_s)
        end

        private
        def status? region
          @status ||= fetch
          region_status = @status.find do |r|
            r[:region] == REGIONS[region.to_s][:label]
          end

          region_status[:status]
        end
      end
    end
  end
end
