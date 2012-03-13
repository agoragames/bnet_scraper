# BnetScraper [![Build Status](https://secure.travis-ci.org/agoragames/bnet_scraper.png)](http://travis-ci.org/agoragames/bnet_scraper)

BnetScraper is a Nokogiri-based scraper of Battle.net profile information.  Currently this only includes Starcraft2.

# Installation

Run `gem install bnet_scraper` or add `gem 'bnet_scraper'` to your `Gemfile`.

# Usage

All of the scrapers take an options hash, and can be created by either passing a URL string for the profile URL or
passing the account information in the options hash.  Thus, either of these two approaches work:

``` ruby
BnetScraper::Starcraft2::ProfileScraper.new(url: 'http://us.battle.net/sc2/en/profile/12345/1/TestAccount/')
BnetScraper::Starcraft2::ProfileScraper.new(bnet_id: '12345', account: 'TestAccount', region: 'na')
```

There are several scrapers that pull various information.  They are:

* BnetScraper::Starcraft2::ProfileScraper - collects basic profile information and an array of league URLs
* BnetScraper::Starcraft2::LeagueScraper - collects data on a particular league for a particular Battle.net account
* BnetScraper::Starcraft2::AchievementScraper - collects achievement data for the account.
* BnetScraper::Starcraft2::MatchHistoryScraper - collects the 25 most recent matches played on the account

All scrapers have a `#scrape` method that triggers the scraping and storage.  By default they will return the result,
but an additional `#output` method exists to retrieve the results subsequent times without re-scraping.

## BnetScraper::Starcraft2::ProfileScraper

This pulls basic profile information for an account, as well as an array of league URLs.  This is a good starting
point for league scraping as it provides the league URLs necessary to do supplemental scraping.

``` ruby
scraper = BnetScraper::Starcraft2::ProfileScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/')
scraper.scrape
# => {
  bnet_id: '2377239',
  account: 'Demon',
  bnet_index: 1,
  race: 'Protoss',
  wins: '684',
  achievement_points: '3630',
  leagues: [
    {
      name: "1v1 Platinum Rank 95",
      id:   "96905",
      href: "http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/96905#current-rank"
    }
  ]
}
```

## BnetScraper::Starcraft2::LeagueScraper

This pulls information on a specific league for a specific account.  It is best used either in conjunction with a
profile scrape that profiles a URL, or if you happen to know the specific league\_id and can pass it as an option.

``` ruby
scraper = BnetScraper::Starcraft2::LeagueScraper.new(league_id: '12345', account: 'Demon', bnet_id: '2377239')
scraper.scrape
# => {
  season: '6',
  name: 'Aleksander Pepper',
  division: 'Diamond',
  size: '4v4',
  random: false,
  bnet_id: '2377239',
  account: 'Demon'
}
```

## BnetScraper::Starcraft2::AchievementScraper

This pulls achievement information for an account.  Note that currently only returns the overall achievements,
not the in-depth, by-category achievement information.

``` ruby
scraper = BnetScraper::Starcraft2::AchievementScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/')
scraper.scrape
# => {
  recent: [
    { title: 'Blink of an Eye', description: 'Complete round 24 in "Starcraft Master" without losing any stalkers', earned: '3/5/2012' },
    { title: 'Whack-a-Roach', description: 'Complete round 9 in "Starcraft Master" in under 45 seconds', earned: '3/5/2012' },
    { title: 'Safe Zone', description: 'Complete round 8 in "Starcraft Master" without losing any stalkers', earned: '3/5/2012' },
    { title: 'Starcraft Master', description: 'Complete all 30 rounds in "Starcraft Master"', earned: '3/5/2012' },
    { title: 'Starcraft Expert', description: 'Complete any 25 rounds in "Starcraft Master"', earned: '3/5/2012' },
    { title: 'Starcraft Apprentice', description: 'Complete any 20 rounds in "Starcraft Master"', earned: '3/5/2012' }
  ],
  showcase: [
    { title: 'Hot Shot', description: 'Finish a Qualification Round with an undefeated record.' },
    { title: 'Starcraft Master', description: 'Complete all rounds in "Starcraft Master"' },
    { title: 'Team Protoss 500', description: 'Win 500 team league matches as Protoss' },
    { title: 'Night of the Living III', description: 'Survive 15 Infested Horde Attacks in the "Night 2 Die" mode of the "Left 2 Die" scenario.' },
    { title: 'Team Top 100 Diamond', description: 'Finish a Season in Team Diamond Division' }
												
  ],
  progress: {
    liberty_campaign: '1580',
    exploration: '480',
    custom_game: '330',
    cooperative: '660',
    quick_match: '170'
  }
}
```

## BnetScraper::Starcraft2::MatchHistoryScraper

This pulls the 25 most recent matches played for an account. Note that this is only as up-to-date as battle.net is, and
will likely not be as fast as in-game.

``` ruby
scraper = BnetScraper::Starcraft2::MatchHistoryScraper.new(url: 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/')
scraper.scrape
# => {
  wins: '15',
  losses: '10',
  matches: [
    { map_name: 'Bx Monobattle - Sand Canyon (Fix)', outcome: :win, type: 'Custom', date: '3/12/2012' },
    { map_name: 'Deadlock Ridge', outcome: :loss, type: '4v4', date: '3/12/2012' },
    { map_name: 'District 10', outcome: :win, type: '4v4', date: '3/12/2012' },
    # ...
  ]
}
```

# Contribute!

I would love to see contributions!  Please send a pull request with a feature branch containing specs 
(Chances are excellent I will break it if you do not) and I will take a look.  Please do not change the version
as I tend to bundle multiple fixes together before releasing a new version anyway.

# Author

Written by [Andrew Nordman](http://github.com/cadwallion), see LICENSE for details.
