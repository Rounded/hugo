task :send_sms => :environment do
	puts Telapi::Message.create( '18454758691', '8457979516', 'This works' )
end

task :get_messages => :environment do
	puts YAML.dump Telapi::Message.list
end