
module BnetScraper
  module Starcraft2
    class Profile
      attr_accessor :portrait, :url, :achievement_points, :current_solo_league, 
        :highest_solo_league, :current_team_league, :highest_team_league,
        :career_games, :games_this_season, :terran_swarm_level, :protoss_swarm_level,
        :zerg_swarm_level, :leagues, :achievements

      def initialize options = {}
        options.each_key do |key|
          self.send "#{key}=", options[key]
        end
      end
    end
  end
end
