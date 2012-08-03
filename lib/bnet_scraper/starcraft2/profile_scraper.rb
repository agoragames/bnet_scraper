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
    #     leagues: [
    #       {
    #         name: "1v1 Platinum Rank 95",
    #         id:   "96905",
    #         href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96905#current-rank"
    #       }
    #     ]
    #   }
    class ProfileScraper < BaseScraper
      attr_reader :achievement_points, :career_games, :race, :leagues, :most_played,
        :games_this_season, :highest_solo_league, :current_solo_league, :highest_team_league,
        :current_team_league

      def initialize options = {}
        super
        @leagues = []
      end

      def scrape
        get_profile_data
        get_league_list
        output
      end

      # scrapes the profile page for basic account information
      def get_profile_data
        response = Faraday.get profile_url

        if response.success?
          html = Nokogiri::HTML(response.body)


          @race = html.css(".stat-block:nth-child(4) h2").inner_html()
          @achievement_points = html.css("#profile-header h3").inner_html()
          @career_games = html.css(".stat-block:nth-child(3) h2").inner_html()
          @most_played = html.css(".stat-block:nth-child(2) h2").inner_html()
          @games_this_season = html.css(".stat-block:nth-child(1) h2").inner_html()

          if html.css("#best-finish-SOLO div")[0]
            @highest_solo_league = html.css("#best-finish-SOLO div")[0].children[2].inner_text.strip
            @current_solo_league = html.css("#best-finish-SOLO div")[0].children[8].inner_text.strip
          else
            @highest_solo_league = "Not Yet Ranked"
            @current_solo_league = "Not Yet Ranked"
          end

          if html.css("#best-finish-TEAM div")[0] 
            @highest_team_league = html.css("#best-finish-TEAM div")[0].children[2].inner_text.strip
            @current_team_league = html.css("#best-finish-TEAM div")[0].children[8].inner_text.strip
          else
            @highest_team_league = "Not Yet Ranked"
            @current_team_league = "Not Yet Ranked"
          end

        else
          raise BnetScraper::InvalidProfileError
        end
      end

      # scrapes the league list from account's league page and sets an array of URLs
      def get_league_list
        response = Faraday.get profile_url + "ladder/leagues"
        if response.success?
          html = Nokogiri::HTML(response.body)

          @leagues = html.css("a[href*='#current-rank']").map do |league|
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
          leagues: @leagues
        }  
      end
    end
  end
end
