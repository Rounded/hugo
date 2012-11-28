class Venue
  include Mongoid::Document

  field :neighborhood, type: Hash
  field :power_outage_percentage, type: Integer

  def self.location_search(zip, from_number)
    query = "hotel"
    # Connect to 4SQ
    client = Foursquare2::Client.new(:client_id => 'SMPGEQCWEVNRIF3UQTYOQSTXCD5VPAPNWLYD2O04XPUIBVCE', :client_secret => 'SARCGLTZZFM4WBOSZSNLJPNFVMDFQPWAVWW1ZLETDST5HFBD')
    # Search 4SQ Explore for stuff
    response = client.explore_venues(near: "#{zip}", :query => "#{query}", limit: "50")
    response_items = response.groups.first.items
    # Grab just the venue info
    venues = response_items.collect{|item| item.venue }
    # Grab the neighborhoods from ConEd
    report = Sandy::Provider::ConEd::Report.new
    neighborhoods = report.neighborhoods
    places = []
    # iterate through venues adding in power information
    venues.each do |venue|
      # we dont want locations without numbas!
      unless venue.contact['formattedPhone'].blank?
        # Object to store place data
        place = OpenStruct.new
        place.marshal_load(venue)
        venue_location = [venue.location["lat"], venue.location["lng"]]
        # iterate through each neighborhood finding the closest one to the venue location. 
        hoods = []
        neighborhoods.each do |hood|
          if hood.latitude.blank? || hood.longitude.blank?
          else
            distance = Geocoder::Calculations.distance_between(venue_location, [hood.latitude, hood.longitude])
            new_hood = {name: hood.name, customers_affected: hood.customers_affected, total_customers: hood.total_customers, estimated_recovery_time: hood.estimated_recovery_time, distance: distance}
            hoods << new_hood
          end
        end
        # below is the most likely
        hood = hoods.flatten.sort_by{|hood| hood[:distance]}.first
        # calculate the percentage of people without power
        power_outage_percentage = (hood[:customers_affected].to_f / hood[:total_customers].to_f) * 100
        # round that shit off
        power_outage_percentage = power_outage_percentage.ceil
        # Add power info to the place struct
        place.power_outage_percentage = power_outage_percentage
        place.neighborhood = hood
        places << place
      end
    end
    # Prioritize the hotels with the most likelihood of power
    places.sort_by{|place| place.power_outage_percentage}
    # Only show the user the best 5
    alerted_places = places.first(5)
    Telapi.config do |config|
      config.account_sid = 'ACbbcf2b79541543ff86dd9955952d1076'
      config.auth_token  = 'bc039f3d301a4475899cb9e31cb3d953'
    end
    # #{venue.contact['formattedPhone']}"
    alerted_places.each do |venue|
     Telapi::Message.create( "#{from_number}", '(302) 752-4624', "#{venue.name}\n#{venue.location['address']}\n#{venue.location.city}, #{venue.location.state} #{venue.location['postalCode']}\n(845) 797-9516" )
    end
  end

end
