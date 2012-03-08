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
  end
end
