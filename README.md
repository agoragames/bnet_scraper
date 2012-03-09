# BnetScraper

A Nokogiri-based scraper of Battle.net profiles.  Currently this only includes Starcraft2.

# Usage

The gem allows you to parse profiles separate from individual leagues, using `BnetScraper::Starcraft2::ProfileScraper`
or `BnetScraper::Starcraft2::LeagueScraper`.  See documentation for more information on those.

One convenience function, `BnetScraper::Starcraft2#full_profile_scrape`, exists to do a full scrape of a given profile.
Note that this is a rather slow function given the number of HTTP calls necessary to retrieve all of the data.
