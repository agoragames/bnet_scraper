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
      [
        'Kachinsky', 'Cade', 'Thatcher', 'Hall', 'Tiger Marine', 'Panda Marine', 
        'General Warfield', 'Jim Raynor', 'Arcturus Mengsk', 'Sarah Kerrigan', 'Kate Lockwell', 'Rory Swann',
        'Egon Stetmann', 'Hill', 'Adjutant', 'Dr. Ariel Hanson', 'Gabriel Tosh', 'Matt Horner', 
        'Tychus Findlay', 'Zeratul', 'Valerian Mengsk', 'Spectre', 'Raynor Marine', 'Tauren Marine',
        'Night Elf Banshee', 'Diablo Marine', 'SCV', 'Firebat', 'Vulture', 'Hellion', 
        'Medic', 'Spartan Company', 'Wraith', 'Diamondback', 'Probe', 'Scout'
      ],
      [
        'Tauren Marine', 'Night Elf Banshee', 'Diablo Marine', 'Worgen Marine', 'Goblin Marine', 'PanTerran Marine', 
        'Wizard Templar', 'Tyrael Marine', 'Witch Doctor Zergling', 'Stank', 'Night Elf Templar', 'Infested Orc',
        '', 'Diablo Marine', '', 'Pandaren Firebat', 'Prince Valerian', 'Zagara',
        'Lasarra', 'Dehaka', 'Infested Stukov', 'Mira Horner', 'Primal Queen', 'Izsha',
        'Abathur', 'Ghost Kerrigan', 'Zurvan', 'Narud', '', '',
        '', '', '', '', '', ''
      ],
      [
        'Ghost', 'Thor', 'Battlecruiser', 'Nova', 'Zealot', 'Stalker', 
        'Phoenix', 'Immortal', 'Void Ray', 'Colossus', 'Carrier', 'Tassadar',
        'Reaper', 'Sentry', 'Overseer', 'Viking', 'High Templar', 'Mutalisk',
        'Banshee', 'Hybrid Destroyer', 'Dark Voice', 'Urubu', 'Lyote', 'Automaton 2000',
        'Orian', 'Wolf Marine', 'Murloc Marine', 'Worgen Marine', 'Goblin Marine', 'Zealot Chef', 
        'Stank', 'Ornatus', 'Facebook Corps Members', 'Lion Marines', 'Dragons', 'Raynor Marine'
      ],
      [
        'Urun', 'Nyon', 'Executor', 'Mohandar', 'Selendis', 'Artanis', 
        'Drone', 'Infested Colonist', 'Infested Marine', 'Corruptor', 'Aberration', 'Broodlord', 
        'Overmind', 'Leviathan', 'Overlord', 'Hydralisk Marine', "Zer'atai Dark Templar", 'Goliath', 
        'Lenassa Dark Templar', 'Mira Han', 'Archon', 'Hybrid Reaver', 'Predator', 'Unknown',
        'Zergling', 'Roach', 'Baneling', 'Hydralisk', 'Queen', 'Infestor', 
        'Ultralisk', 'Queen of Blades', 'Marine', 'Marauder', 'Medivac', 'Siege Tank'
      ],
      [
        'Level 3 Zealot', 'Level 5 Stalker', 'Level 8 Sentinel', 'Level 11 Immortal', 'Level 14 Oracle', 'Level 17 High Templar',
        'Level 21 Tempest', 'Level 23 Colossus', 'Level 27 Carrier', 'Level 29 Zeratul', 'Level 3 Marine', 'Level 5 Marauder',
        'Level 8 Hellbat', 'Level 11 Widow Mine', 'Level 14 Medivac', 'Level 17 Banshee', 'Level 21 Ghost', 'Level 23 Thor',
        'Level 27 Battlecruiser', 'Level 29 Raynor', 'Level 3 Zergling', 'Level 5 Roach', 'Level 8 Hydralisk', 'Level 11 Locust',
        'Level 14 Swarm Host', 'Level 17 Infestor', 'Level 21 Viper', 'Level 23 Broodlord', 'Level 27 Ultralisk', 'Level 29 Kerrigan',
        'Protoss Champion',' Terran Champion', 'Zerg Champion', '', '', ''
      ]
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
      profile.leagues.each do |league|
        league.scrape_league
      end
      profile.achievements
      profile.match_history
      
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
