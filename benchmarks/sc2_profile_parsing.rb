$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'benchmark'
require 'bnet_scraper'

@@bnet_accounts = [
  { bnet_id: 2377239, name: 'Demon', race: 'protoss' },
  { bnet_id: 2035618, name: 'Mykaelos', race: 'random' },
  { bnet_id: 1826063, name: 'Fyrefly', race: 'zerg' },
  { bnet_id: 2539344, name: 'Cadwallion', race: 'terran' }
]

def parse_random_account
  account = @@bnet_accounts[rand(@@bnet_accounts.size)] 
  BnetScraper::Starcraft2::ProfileScraper.new(account[:bnet_id], account[:name]).scrape
end

Benchmark.bmbm(7) do |x|
  x.report('1') { parse_random_account }
  x.report('5') { 5.times { parse_random_account } }
  x.report('10') { 10.times { parse_random_account } }
  x.report('25') { 25.times { parse_random_account } }
  x.report('50') { 50.times { parse_random_account } }
end
