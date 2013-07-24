module BnetScraper
  module Starcraft2
    class Achievement
      attr_accessor :title, :description, :earned

      def initialize options = {}
        options.each_key do |key|
          self.send "#{key}=", options[key]
        end
      end
    end
  end
end
