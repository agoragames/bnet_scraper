$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'bnet_scraper'
require 'pry'
require 'vcr'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
  config.hook_into :fakeweb
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.around(:each, :vcr) do |example|
     name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
     VCR.use_cassette(name) { example.call }
  end
end
