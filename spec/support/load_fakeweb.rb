require 'fakeweb'

profile_html  = File.read File.dirname(__FILE__) + '/profile.html' 
league_html   = File.read File.dirname(__FILE__) + '/league.html' 

FakeWeb.allow_net_connect = false
FakeWeb.register_uri :get, 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/', body: profile_html, status: 200, content_type: 'text/html'
FakeWeb.register_uri :get, 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/ladder/12345', body: league_html, status: 200, content_type: 'text/html'
