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
      attr_reader :achievement_points, :wins, :race, :leagues
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

          if race_div = html.css("#season-snapshot .module-footer a").first()
            @race = race_div.inner_html()
          end

          @wins = html.css("#career-stats h2").inner_html()
          @achievement_points = html.css("#profile-header h3").inner_html()
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
          wins: @wins,
          achievement_points: @achievement_points,
          leagues: @leagues
        }  
      end
    end
  end
end
