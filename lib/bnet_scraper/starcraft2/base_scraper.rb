module BnetScraper
  module Starcraft2
    class BaseScraper
      attr_reader :bnet_id, :account, :region, :bnet_index, :url

      def initialize options = {}
        if options[:url]
          extracted_data = options[:url].match(/http:\/\/(.+)\/sc2\/(.+)\/profile\/(.+)\/(\d{1})\/(.[^\/]+)\//)
          @region     = REGIONS.key({ domain: extracted_data[1], dir: extracted_data[2] })
          @bnet_id    = extracted_data[3]
          @bnet_index = extracted_data[4]
          @account    = extracted_data[5]
          @url        = options[:url]
        elsif options[:bnet_id] && options[:account]
          @bnet_id  = options[:bnet_id]
          @account  = options[:account]
          @region   = options[:region] || 'na'
          if options[:bnet_index]
            @bnet_index = options[:bnet_index]
          else
            set_bnet_index
          end
        end
      end

      # set_bnet_index
      # 
      # Because profile URLs have to have a specific bnet_index that is seemingly incalculable,
      # we must ping both variants to determine the correct bnet_index. We then store that value.
      def set_bnet_index
        [1,2].each do |idx|
          res = Net::HTTP.get_response URI profile_url idx 
          if res.is_a? Net::HTTPSuccess
            @bnet_index = idx
            return
          end
        end
      end

      def profile_url bnet_index = @bnet_index
        "http://#{region_info[:domain]}/sc2/#{region_info[:dir]}/profile/#{bnet_id}/#{bnet_index}/#{account}/"
      end

      def region_info
        REGIONS[region] 
      end
    end
  end
end
