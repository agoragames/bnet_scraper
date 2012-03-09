require 'bnet_scraper/starcraft2/profile_scraper'
require 'bnet_scraper/starcraft2/league_scraper'

module BnetScraper
  # This module contains everything about scraping Starcraft 2 Battle.net accounts.
  # See `BnetScraper::Starcraft2::ProfileScraper` and `BnetScraper::Starcraft2::LeagueScraper`
  # for more details
  module Starcraft2
    REGIONS = {
      'na'  => { domain: 'us.battle.net', dir: 'en' },
      'eu'  => { domain: 'eu.battle.net', dir: 'eu' },
      'cn'  => { domain: 'www.battlenet.com.cn', dir: 'zh' },
      'sea' => { domain: 'sea.battle.net', dir: 'en' },
      'fea' => { domain: 'tw.battle.net', dir: 'zh' } 
    }

    # This is a convenience method that chains calls to ProfileScraper,
    # followed by a scrape of each league returned in the `leagues` array
    # in the profile_data.  The end result is a fully scraped profile with
    # profile and league data in a hash.
    #
    # See `BnetScraper::Starcraft2::ProfileScraper` for more information on
    # the parameters being sent to `#full_profile_scrape`.
    #
    # @param bnet_id - Battle.net Account ID 
    # @param account - Battle.net Account Name
    # @param region  - Battle.net Account Region
    # @return profile_data - Hash containing complete profile and league data
    #   scraped from the website
    def self.full_profile_scrape bnet_id, account, region = 'na'
      profile_scraper = ProfileScraper.new bnet_id: bnet_id, account: account, region: region
      profile_output  = profile_scraper.scrape

      parsed_leagues = []
      profile_output[:leagues].each do |league|
        league_scraper = LeagueScraper.new league[:href]
        parsed_leagues << league_scraper.scrape
      end
      profile_output[:leagues] = parsed_leagues
      return profile_output
    end
  end
end
