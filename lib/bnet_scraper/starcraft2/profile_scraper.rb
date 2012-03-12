module BnetScraper
  module Starcraft2
    # ProfileScraper
    #
    # Scrapes SC2 profile data from battle.net and returns it as a hash.  Example:
    #   profile_data = BnetScraper::Starcraft2::ProfileScraper.new('2377239', 'Demon')
    #   profile_data # => { bnet_id: '2377239', account: 'Demon', race: 'Protoss', 
    #                       wins: '684', achievements: '3260', leagues: [], bnet_index: 1 }
    #
    # One thing of note is the bnet_index. In Battle.net URLs, there is a single-digit index
    # used on accounts (1 or 2).  This index is seemingly arbitrary, but critical to properly
    # accessing the data.
    #
    # ProfileScraper requires that either you pass the URL of the profile, or the bnet_id and
    # account name of the profile.  The URL scheme is as such:
    #
    #   http://<REGION_DOMAIN>/sc2/<REGION_LANG>/profile/<BNET_ID>/<BNET_INDEX>/<ACCOUNT>/
    #
    # Using this URL we can extract the critical information.  However, sometimes we do not have
    # the URL and have to make do with a bnet_id and account.  This is the bare minimum needed,
    # unless the account is in a region other than 'na'.  In such cases, region all needs to be passed.
    class ProfileScraper < BaseScraper
      def scrape
        get_profile_data
        get_league_list
        output
      end

      def get_profile_data
        response = Nokogiri::HTML(open(profile_url))

        @race = response.css("#season-snapshot .module-footer a").first().inner_html()
        @wins = response.css("#career-stats h2").inner_html()
        @achievements = response.css("#profile-header h3").inner_html()
      end

      def get_league_list
        response = Nokogiri::HTML(open(profile_url + "ladder/leagues"))

        @leagues = response.css("a[href*='#current-rank']").map do |league|
          {
            name: league.inner_html().strip,
            id: league.attr('href').sub('#current-rank',''),
            href: "#{profile_url}ladder/#{league.attr('href')}"
          }
        end
      end

      def output
         {
          bnet_id: @bnet_id,
          account: @account,
          bnet_index: @bnet_index,
          race: @race,
          wins: @wins,
          achievements: @achievements,
          leagues: @leagues
        }  
      end
    end
  end
end
