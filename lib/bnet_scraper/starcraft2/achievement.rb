require 'date'
module BnetScraper
  module Starcraft2
    class Achievement
      attr_accessor :title, :description
      attr_reader :earned

      def earned= date
        @earned = convert_date date
      end

      def convert_date date
        month, day, year = date.scan(/(\d+)\/(\d+)\/(\d+)/).first.map(&:to_i)
        Date.new year, month, day
      end
    end
  end
end
