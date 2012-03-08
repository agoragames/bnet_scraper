require 'bnet_scraper/starcraft2/profile_scraper'
require 'bnet_scraper/starcraft2/league_scraper'

module BnetScraper
  module Starcraft2
    REGIONS = {
      'na'  => { domain: 'us.battle.net', dir: 'en' },
      'eu'  => { domain: 'eu.battle.net', dir: 'eu' },
      'cn'  => { domain: 'www.battlenet.com.cn', dir: 'zh' },
      'sea' => { domain: 'sea.battle.net', dir: 'en' },
      'fea' => { domain: 'tw.battle.net', dir: 'zh' } 
    }

    def self.full_profile_scrape bnet_id, account, region = 'na'
      profile_scraper = ProfileScraper.new bnet_id, account, region
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
