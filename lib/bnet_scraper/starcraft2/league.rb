module BnetScraper
  module Starcraft2
    class League
      attr_accessor :id, :name, :href

      def initialize options = {}
        options.each_key do |key|
          self.send "#{key}=", options[key]
        end
      end
    end
  end
end
