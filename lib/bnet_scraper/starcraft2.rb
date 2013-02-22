require 'bnet_scraper/starcraft2/base_scraper'
require 'bnet_scraper/starcraft2/profile_scraper'
require 'bnet_scraper/starcraft2/league_scraper'
require 'bnet_scraper/starcraft2/achievement_scraper'
require 'bnet_scraper/starcraft2/match_history_scraper'
require 'bnet_scraper/starcraft2/status_scraper'

module BnetScraper
  # This module contains everything about scraping Starcraft 2 Battle.net accounts.
  # See `BnetScraper::Starcraft2::ProfileScraper` and `BnetScraper::Starcraft2::LeagueScraper`
  # for more details
  module Starcraft2
    REGIONS = {
      'na'  => { domain: 'us.battle.net', dir: 'en', label: 'North America' },
      'eu'  => { domain: 'eu.battle.net', dir: 'en', label: 'Europe' },
      'cn'  => { domain: 'www.battlenet.com.cn', dir: 'zh', label: 'China' },
      'sea' => { domain: 'sea.battle.net', dir: 'en', label: 'South-East Asia' },
      'fea' => { domain: 'tw.battle.net', dir: 'zh', label: 'Korea' }
    }

    REGION_DOMAINS = {
      'us.battle.net' => 'na',
      'eu.battle.net' => 'eu',
      'www.battlenet.com.cn' => 'cn',
      'sea.battle.net' => 'sea',
      'kr.battle.net' => 'fea',
      'tw.battle.net' => 'fea'
    }

    # The armory uses spritemaps that are sequentially named and have a fixed
    # 6x6 grid. We'll simply use the portrait names, left to right, top to
    # bottom.
    #
    # Note: I couldn't identify the exact names of some of these and instead of
    # guessing, I didn't name them. Some appear in multiple files too, which 
    # is odd.
    #
    # I decided th pad the arrays even if there are no images to make various
    # helping functionality (e.g. retrieving position for a name) easier.
    # I've also kept them in 6x6 here for better overview.
    PORTRAITS = [
      # http://eu.battle.net/sc2/static/local-common/images/sc2/portraits/0-75.jpg?v42
      ['Kachinsky', 'Cade', 'Thatcher', 'Hall', 'Tiger Marine', 'Panda Marine', 
      'General Warfield', 'Jim Raynor', 'Arcturus Mengsk', 'Sarah Kerrigan', 'Kate Lockwell', 'Rory Swann', 
      'Egon Stetmann', 'Hill', 'Adjutant', 'Dr. Ariel Hanson', 'Gabriel Tosh', 'Matt Horner', 
      # Could not identify in order: Raynor in a Suit? Bullmarine? Nova? 
      # Fiery Marine?
      'Tychus Findlay', 'Zeratul', 'Valerian Mengsk', 'Spectre', '?', '?',
      '?', '?', 'SCV', 'Firebat', 'Vulture', 'Hellion', 
      'Medic', 'Spartan Company', 'Wraith', 'Diamondback', 'Probe', 'Scout'],

      # http://eu.battle.net/sc2/static/local-common/images/sc2/portraits/1-75.jpg?v42
      # Special Rewards - couldn't identify most of these.
      ['?', '?', '?', '?', '?', 'PanTerran Marine', 
      '?', '?', '?', '?', '', '',
      '', '', '', '', '', '',
      '', '', '', '', '', '',
      '', '', '', '', '', '',
      '', '', '', '', '', ''],

      # http://eu.battle.net/sc2/static/local-common/images/sc2/portraits/2-75.jpg?v42
      ['Ghost', 'Thor', 'Battlecruiser', 'Nova', 'Zealot', 'Stalker', 
      'Phoenix', 'Immortal', 'Void Ray', 'Colossus', 'Carrier', 'Tassadar',
      'Reaper', 'Sentry', 'Overseer', 'Viking', 'High Templar', 'Mutalisk',
      # Unidentified: Bird? Dog? Robot?
      'Banshee', 'Hybrid Destroyer', 'Dark Voice', '?', '?', '?',
      # Unidentified: Worgen? Goblin? Chef?
      'Orian', 'Wolf Marine', 'Murloc Marine', '?', '?', 'Zealot Chef', 
      # Unidentified: KISS Marine? Dragon Marine? Dragon? Another Raynor?
      'Stank', 'Ornatus', '?', '?', '?', '?'],

      # http://eu.battle.net/sc2/static/local-common/images/sc2/portraits/3-75.jpg?v42
      ['Urun', 'Nyon', 'Executor', 'Mohandar', 'Selendis', 'Artanis', 
      'Drone', 'Infested Colonist', 'Infested Marine', 'Corruptor', 'Aberration', 'Broodlord', 
      'Overmind', 'Leviathan', 'Overlord', 'Hydralisk Marine', "Zer'atai Dark Templar", 'Goliath', 
      # Unidentified: Satan Marine?
      'Lenassa Dark Templar', 'Mira Han', 'Archon', 'Hybrid Reaver', 'Predator', '?',
      'Zergling', 'Roach', 'Baneling', 'Hydralisk', 'Queen', 'Infestor', 
      'Ultralisk', 'Queen of Blades', 'Marine', 'Marauder', 'Medivac', 'Siege Tank']
    ]

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
      profile = profile_scraper.scrape
      profile.leagues
      profile.achievements
      
      return profile
    end

    # Determine if Supplied profile is valid.  Useful for validating now before an 
    # async scraping later
    #
    # @param [Hash] options - account information hash
    # @return [TrueClass, FalseClass] valid - whether account is valid
    def self.valid_profile? options
      scraper = BaseScraper.new(options)
      scraper.valid?
    end
  end
end
