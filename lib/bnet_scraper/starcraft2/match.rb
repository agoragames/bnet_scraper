module BnetScraper
  module Starcraft2
    class Match
      attr_accessor :outcome, :map_name, :type, :date

      def won?
        @outcome == :won
      end

      def lost?
        @outcome == :loss
      end
    end
  end
end
