task :find_hotel => :environment do
  client = Foursquare2::Client.new(:client_id => 'SMPGEQCWEVNRIF3UQTYOQSTXCD5VPAPNWLYD2O04XPUIBVCE', :client_secret => 'SARCGLTZZFM4WBOSZSNLJPNFVMDFQPWAVWW1ZLETDST5HFBD')

  response = client.explore_venues(near: "10016", :query => 'hotel', limit: "50")
  response_items = response.groups.first.items

  venues = response_items.collect{|item| item.venue }
  puts venues.count
end