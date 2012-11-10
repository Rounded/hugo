class Venue
  include Mongoid::Document

  field :neighborhood, type: Hash
  field :power_outage_percentage, type: Integer

  def self.location_search
    client = Foursquare2::Client.new(:client_id => 'SMPGEQCWEVNRIF3UQTYOQSTXCD5VPAPNWLYD2O04XPUIBVCE', :client_secret => 'SARCGLTZZFM4WBOSZSNLJPNFVMDFQPWAVWW1ZLETDST5HFBD')
    response = client.explore_venues(near: "10016", :query => 'hotel', limit: "50")
    response_items = response.groups.first.items
    venues = response_items.collect{|item| item.venue }
    Venue.collection.insert(venues)
  end

  def find_closest_neighborhood
    venue_location = [location["lat"], location["lng"]]
    report = Sandy::Provider::ConEd::Report.new
    neighborhoods = report.neighborhoods

    hoods = []

    neighborhoods.each do |hood|
      if hood.latitude.blank? || hood.longitude.blank?
      else
        distance = Geocoder::Calculations.distance_between(venue_location, [hood.latitude, hood.longitude])
        new_hood = {name: hood.name, customers_affected: hood.customers_affected, total_customers: hood.total_customers, estimated_recovery_time: hood.estimated_recovery_time, distance: distance}
        hoods << new_hood
      end
    end
    hood = hoods.flatten.sort_by{|hood| hood[:distance]}.first
    power_percentage = (hood[:customers_affected].to_f / hood[:total_customers].to_f) * 100
    self.power_outage_percentage = power_percentage.ceil
    self.neighborhood = hood
    self.save
  end





end
