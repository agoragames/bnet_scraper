module BnetScraper
  module Starcraft2
    # Portrait information pulled from the Armory.  Portraits are 90-pixel jpgs that are either viewed as a single
    # image or as part of a 6x6 spritesheet.  There are several spritesheets with a few cells in the sheets not yet
    # filled but will be in the future.
    #
    # The Profile page uses the spritesheet version of the Portrait with an X/Y background position. This is 
    # converted into sheet, column, and row, which allows us to know the name and map to the single image url as
    # well.
    class Portrait
      # The armory uses spritemaps that are sequentially named and have a fixed
      # 6x6 grid. We'll simply use the portrait names, left to right, top to
      # bottom. The sheets are padded even when no portrait is present to account for the 36-image sheet
      NAMES = [
        # SPRITESHEET 1
        'Kachinsky', 'Cade', 'Thatcher', 'Hall', 'Tiger Marine', 'Panda Marine', 
        'General Warfield', 'Jim Raynor', 'Arcturus Mengsk', 'Sarah Kerrigan', 'Kate Lockwell', 'Rory Swann',
        'Egon Stetmann', 'Hill', 'Adjutant', 'Dr. Ariel Hanson', 'Gabriel Tosh', 'Matt Horner', 
        'Tychus Findlay', 'Zeratul', 'Valerian Mengsk', 'Spectre', 'Raynor Marine', 'Tauren Marine',
        'Night Elf Banshee', 'Diablo Marine', 'SCV', 'Firebat', 'Vulture', 'Hellion', 
        'Medic', 'Spartan Company', 'Wraith', 'Diamondback', 'Probe', 'Scout',
        # SPRITESHEET 2
        'Tauren Marine', 'Night Elf Banshee', 'Diablo Marine', 'Worgen Marine', 'Goblin Marine', 'PanTerran Marine', 
        'Wizard Templar', 'Tyrael Marine', 'Witch Doctor Zergling', 'Stank', 'Night Elf Templar', 'Infested Orc',
        '', 'Diablo Marine', '', 'Pandaren Firebat', 'Prince Valerian', 'Zagara',
        'Lasarra', 'Dehaka', 'Infested Stukov', 'Mira Horner', 'Primal Queen', 'Izsha',
        'Abathur', 'Ghost Kerrigan', 'Zurvan', 'Narud', '', '15 Year Terran',
        '15 Year Protoss', '15 Year Zerg', '', '', '', '',
        # SPRITESHEET 3
        'Ghost', 'Thor', 'Battlecruiser', 'Nova', 'Zealot', 'Stalker', 
        'Phoenix', 'Immortal', 'Void Ray', 'Colossus', 'Carrier', 'Tassadar',
        'Reaper', 'Sentry', 'Overseer', 'Viking', 'High Templar', 'Mutalisk',
        'Banshee', 'Hybrid Destroyer', 'Dark Voice', 'Urubu', 'Lyote', 'Automaton 2000',
        'Orian', 'Wolf Marine', 'Murloc Marine', 'Worgen Marine', 'Goblin Marine', 'Zealot Chef', 
        'Stank', 'Ornatus', 'Facebook Corps Members', 'Lion Marines', 'Dragons', 'Raynor Marine',
        # SPRITESHEET 4
        'Urun', 'Nyon', 'Executor', 'Mohandar', 'Selendis', 'Artanis', 
        'Drone', 'Infested Colonist', 'Infested Marine', 'Corruptor', 'Aberration', 'Broodlord', 
        'Overmind', 'Leviathan', 'Overlord', 'Hydralisk Marine', "Zer'atai Dark Templar", 'Goliath', 
        'Lenassa Dark Templar', 'Mira Han', 'Archon', 'Hybrid Reaver', 'Predator', 'Unknown',
        'Zergling', 'Roach', 'Baneling', 'Hydralisk', 'Queen', 'Infestor', 
        'Ultralisk', 'Queen of Blades', 'Marine', 'Marauder', 'Medivac', 'Siege Tank',
        # SPRITESHEET 5
        'Level 3 Zealot', 'Level 5 Stalker', 'Level 8 Sentinel', 'Level 11 Immortal', 'Level 14 Oracle', 'Level 17 High Templar',
        'Level 21 Tempest', 'Level 23 Colossus', 'Level 27 Carrier', 'Level 29 Zeratul', 'Level 3 Marine', 'Level 5 Marauder',
        'Level 8 Hellbat', 'Level 11 Widow Mine', 'Level 14 Medivac', 'Level 17 Banshee', 'Level 21 Ghost', 'Level 23 Thor',
        'Level 27 Battlecruiser', 'Level 29 Raynor', 'Level 11 Locust', 'Level 3 Zergling', 'Level 5 Roach', 'Level 8 Hydralisk', 
        'Level 14 Swarm Host', 'Level 17 Infestor', 'Level 21 Viper', 'Level 23 Broodlord', 'Level 27 Ultralisk', 'Level 29 Kerrigan',
        'Protoss Champion',' Terran Champion', 'Zerg Champion', '', '', ''
      ]
      attr_reader :name, :sheet, :row, :column
      def initialize sheet, pixel_size, pixel_column, pixel_row
        @sheet = sheet
        @column = pixel_column / pixel_size
        @row = pixel_row / pixel_size
        @name = name_from_position
      end

      def name_from_position
        index = (@sheet * 36) + image_position
        NAMES[index]
      end

      # @return [String] The URL to the portrait image iteslf
      def url
        "http://media.blizzard.com/sc2/portraits/#{@sheet}-#{image_position}.jpg"
      end

      # @return [String] The URL to the spritesheet the portrait is part of
      def spritesheet_url
        "http://media.blizzard.com/sc2/portraits/#{@sheet}-90.jpg"
      end

      # The image position within a given 6x6 spritesheet
      #
      # @return [Fixnum] image position within the spritesheet
      def image_position
        (@row * 6) + @column
      end
    end
  end
end
