task :find_hotel => :environment do
  client = Foursquare2::Client.new(:client_id => 'SMPGEQCWEVNRIF3UQTYOQSTXCD5VPAPNWLYD2O04XPUIBVCE', :client_secret => 'SARCGLTZZFM4WBOSZSNLJPNFVMDFQPWAVWW1ZLETDST5HFBD')

  venues = client.explore_venues(near: "13202", :query => 'hotel')

  puts venues

end