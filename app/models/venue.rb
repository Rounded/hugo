class Venue
  include Mongoid::Document



  client = Foursquare2::Client.new(:client_id => 'SMPGEQCWEVNRIF3UQTYOQSTXCD5VPAPNWLYD2O04XPUIBVCE', :client_secret => 'SARCGLTZZFM4WBOSZSNLJPNFVMDFQPWAVWW1ZLETDST5HFBD')

  response = client.explore_venues(near: "10016", :query => 'hotel', limit: "50")
  response_items = response.groups.first.items

  venues = response_items.collect{|item| item.venue }

  

  def find_closest_neighborhood
    venue_location = [location["lat"], location["lng"]]
    report = Sandy::Provider::ConEd::Report.new
    neighborhoods = report.neighborhoods

    distances = []

    neighborhoods.each do |hood|
      if hood.latitude.blank? || hood.longitude.blank?
      else
        distance = Geocoder::Calculations.distance_between(venue_location, [hood.latitude, hood.longitude])
        # hood = distance
        puts hood.longitude
      end
    end
    puts neighborhoods.collect{|hood| hood.longitude}.sort!

  end





end
