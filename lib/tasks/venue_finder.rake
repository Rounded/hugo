task :find_hotel => :environment do

  Venue.location_search("hotel","10016")

end