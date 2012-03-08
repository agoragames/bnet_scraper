require 'fakeweb'

profile_html = File.read File.dirname(__FILE__) + '/profile.html' 

FakeWeb.allow_net_connect = false
FakeWeb.register_uri :get, 'http://us.battle.net/sc2/en/profile/2377239/1/Demon/', body: profile_html, status: 200, content_type: 'text/html'
