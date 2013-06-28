
module BnetScraper
  module Starcraft2
    class Profile
      attr_accessor :portrait, :url, :achievement_points, :current_solo_league, 
        :highest_solo_league, :current_team_league, :highest_team_league,
        :career_games, :games_this_season, :terran_swarm_level, :protoss_swarm_level,
        :zerg_swarm_level, :leagues, :swarm_levels, :terran_campaign_completion,
        :zerg_campaign_completion, :clan_tag, :clan_name

      def initialize options = {}
        options.each_key do |key|
          self.send "#{key}=", options[key]
        end
      end

      def achievements
        @achievements ||= AchievementScraper.new(url: url).scrape
      end

      def recent_achievements
        achievements[:recent]
      end

      def progress_achievements
        achievements[:progress]
      end

      def showcase_achievements
        achievements[:showcase]
      end

      def match_history
        @match_history ||= MatchHistoryScraper.new(url: url).scrape
      end

      def swarm_levels
        {
          zerg: @zerg_swarm_level,
          protoss: @protoss_swarm_level,
          terran: @terran_swarm_level
        }
      end

      def campaign_completion
        {
          terran: @terran_campaign_completion,
          zerg: @zerg_campaign_completion
        }
      end

      def completed_campaign campaign, difficulty = :normal
        difficulties = [:unearned, :normal, :hard, :brutal]
        ranking = campaign_completion[campaign]
        if difficulties.index(ranking) >= difficulties.index(difficulty)
          true
        else
          false
        end
      end
    end
  end
end
