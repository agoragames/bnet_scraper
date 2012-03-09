# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bnet_scraper"
  s.version     = "0.0.1"
  s.authors     = ["Andrew Nordman"]
  s.email       = ["anordman@majorleaguegaming.com"]
  s.homepage    = ""
  s.summary     = %q{Battle.net Profile Scraper}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'nokogiri'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'fakeweb'
end
