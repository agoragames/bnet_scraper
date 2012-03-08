$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'bnet_scraper'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }

