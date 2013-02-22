require 'bnet_scraper/starcraft2/profile'

module BnetScraper
  module Starcraft2
    # This pulls basic profile information for an account, as well as an array of league URLs.  This is a good starting
    # point for league scraping as it provides the league URLs necessary to do supplemental scraping.
    #
    #   scraper = BnetScraper::Starcraft2::ProfileScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/')
    #   scraper.scrape
    #   # => {
    #     bnet_id: '2377239',
    #     account: 'Demon',
    #     bnet_index: 1,
    #     race: 'Protoss',
    #     wins: '684',
    #     achievement_points: '3630',
    #     current_solo_league: 'Not Yet Ranked',
    #     highest_solo_league: 'Platinum',
    #     current_team_league: 'Not Yet Ranked',
    #     highest_team_league: 'Diamond',
    #     career_games: '1568',
    #     games_this_season: '0',
    #     most_played: '4v4',
    #     leagues: [
    #       {
    #         name: "1v1 Platinum Rank 95",
    #         id:   "96905",
    #         href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96905#current-rank"
    #       }
    #     ]
    #   }
    class ProfileScraper < BaseScraper
      attr_reader :achievement_points, :career_games, :leagues, :games_this_season, 
        :highest_solo_league, :current_solo_league, :highest_team_league,
        :current_team_league, :portrait, :terran_swarm_level, :protoss_swarm_level,
        :zerg_swarm_level, :profile

      def initialize options = {}
        super
        @leagues = []
        @profile ||= Profile.new url: url
      end

      def scrape
        get_profile_data
        get_league_list

        @profile
      end

      # scrapes the profile page for basic account information
      def get_profile_data
        response = Faraday.get profile_url

        if response.success?
          html = Nokogiri::HTML(response.body)

          @profile.achievement_points = html.css("#profile-header h3").inner_html()
          @profile.career_games = html.css(".career-stat-block:nth-child(4) .stat-value").inner_html()
          @profile.games_this_season = html.css(".career-stat-block:nth-child(5) .stat-value").inner_html()

          get_portrait html
          get_solo_league_info html
          get_team_league_info html
          get_swarm_levels html
        else
          raise BnetScraper::InvalidProfileError
        end
      end

      def get_portrait html
        # Portraits use spritemaps, so we extract positions and map to 
        # PORTRAITS.
        @profile.portrait = begin
          portrait = html.css("#profile-header #portrait span").attr('style').to_s.scan(/url\('(.*?)'\) ([\-\d]+)px ([\-\d]+)px/).flatten
          portrait_map, portrait_size = portrait[0].scan(/(\d)\-(\d+)\.jpg/)[0]
          portrait_position = (((0-portrait[2].to_i) / portrait_size.to_i) * 6) + ((0-portrait[1].to_i) / portrait_size.to_i + 1)
          PORTRAITS[portrait_map.to_i][portrait_position-1]
        rescue 
          nil
        end
      end

      def get_solo_league_info html
        if html.css("#best-finish-SOLO div")[0]
          @profile.highest_solo_league = html.css("#best-finish-SOLO div")[0].children[2].inner_text.strip
          if html.css("#best-finish-SOLO div")[0].children[8]
            @profile.current_solo_league = html.css("#best-finish-SOLO div")[0].children[8].inner_text.strip
          else
            @profile.current_solo_league = "Not Yet Ranked"
          end
        else
          @profile.highest_solo_league = "Not Yet Ranked"
          @profile.current_solo_league = "Not Yet Ranked"
        end
      end

      def get_team_league_info html
        if html.css("#best-finish-TEAM div")[0] 
          @profile.highest_team_league = html.css("#best-finish-TEAM div")[0].children[2].inner_text.strip
          if html.css("#best-finish-TEAM div")[0].children[8]
            @profile.current_team_league = html.css("#best-finish-TEAM div")[0].children[8].inner_text.strip
          else
            @profile.current_team_league = "Not Yet Ranked"
          end
        else
          @profile.highest_team_league = "Not Yet Ranked"
          @profile.current_team_league = "Not Yet Ranked"
        end
      end

      def get_swarm_levels html
        @profile.protoss_swarm_level = get_swarm_level :protoss, html
        @profile.terran_swarm_level = get_swarm_level :terran, html
        @profile.zerg_swarm_level = get_swarm_level :zerg, html
      end

      def get_swarm_level race, html
        level = html.css(".race-level-block.#{race} .level-value").inner_html
        level.match(/Level (\d+)/)[1].to_i
      end

      # scrapes the league list from account's league page and sets an array of URLs
      def get_league_list
        response = Faraday.get profile_url + "ladder/leagues"
        if response.success?
          html = Nokogiri::HTML(response.body)

          @profile.leagues = html.css("a[href*='#current-rank']").map do |league|
            {
              name: league.inner_html().strip,
              id: league.attr('href').sub('#current-rank',''),
              href: "#{profile_url}ladder/#{league.attr('href')}"
            }
          end
        else
          raise BnetScraper::InvalidProfileError
        end
      end

      def output
         {
          bnet_id: @bnet_id,
          account: @account,
          bnet_index: @bnet_index,
          race: @race,
          current_solo_league: @current_solo_league,
          highest_solo_league: @highest_solo_league,
          current_team_league: @current_team_league,
          highest_team_league: @highest_team_league,
          career_games: @career_games,
          games_this_season: @games_this_season,
          most_played: @most_played,
          achievement_points: @achievement_points,
          leagues: @leagues,
          portrait: @portrait
        }  
      end
    end
  end
end
