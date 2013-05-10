# Changelog!

## 0.6.0 (May 09 2013)

* Adds GrandmasterScraper to pull all grandmasters by region
* Updates Portrait names for anniversary
* Improves portait code
* Documentation updates

## 0.5.0 (Mar 29 2013)

* Adds Heart of the Swarm Portrait Names
* Updates Achievement Progress Categories for Heart of the Swarm
* Adds Achievement to replace hash output
* Replace FakeWeb specs with VCR
* Typecast numerics to Fixnum instead of strings
* Typecast dates to Date instead of Strings (`Achievement#earned=`)
* Fix wins/losses in MatchHistoryScraper
* Adds Campaign Completion indicators (`Profile#campaign_completion`)
* Extensive internal refactoring and decoupling

## 0.4.0 (Feb 22 2013)

* Revamped ProfileScraper API
* Uses VCR for test fixtures
* Switched from Hash output to Profile object on ProfileScraper
* MatchHistoryScraper now returns array of Matches instead of Hashes
* Adds Swarm Level to Profile
* Full-scrape pulls achievements, match history, and league information

## 0.3.1 (Sep 24 2012)

* Throws BnetScraper::InvalidProfileError when instantiating a scraper with poorly
formatted profile URL

## 0.3.0 (Sep 22 2012)

* Adds portrait name scraping to ProfileScraper

## 0.2.1 (Aug 04 2012)

* Adds race condition for profile scraping accounts playing in their first season

## 0.2.0 (Aug 03 2012)

* Adds domain remapping to regions
* Fixes bug with EU profile scraping due to language selection
* Parses new player stats (Career Wins, Most Played Type, Games This Season)
* Parses new league stats (Current/Highest Solo/Team Leagues)

## 0.1.3 (Jul 26 2012)

* Adds checks to prevent parse issues with accounts that don't ladder

## 0.1.2 (Jul 20 2012)

* We don't talk about 0.1.2...

## 0.1.1 (Jul 20 2012)

* Adds BnetScraper::Starcraft2.valid\_profile?
* Adds BnetScraper::Starcraft2::BaseScraper#valid?

## 0.1.0 (Jul 06 2012)

* Replaces open-uri with Faraday
* Adds BnetScraper::InvalidProfileError when unsuccessfully scraping

## 0.0.2 (Apr 20 2012)

* Adds Battle.net Status API
* Adds Match History scraping
* Adds Achievement scraping
* Documentation Improvements
* Adds Travis-CI Support

## 0.1.0 (Mar 13 2012)

* Initial Release
