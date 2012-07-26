# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bnet_scraper"
  s.version     = "0.1.2"
  s.authors     = ["Andrew Nordman"]
  s.email       = ["anordman@majorleaguegaming.com"]
  s.homepage    = "https://github.com/agoragames/bnet_scraper/"
  s.summary     = %q{Battle.net Profile Scraper}
  s.description = %q{BnetScraper is a Nokogiri-based scraper of Battle.net profile information. Currently this only includes Starcraft2.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'faraday'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'
end
