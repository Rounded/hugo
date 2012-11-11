class User
  include Mongoid::Document
  field :name
  field :number, type: Integer

  validates_presence_of :name
  validates_presence_of :number
  validates_numericality_of :number

  after_create :send_first_text

  protected

  # def remove_dashes
  #   number = number.gsub(/\D/, '')
  # end

  def send_first_text
    Telapi.config do |config|
      config.account_sid = 'ACbbcf2b79541543ff86dd9955952d1076'
      config.auth_token  = 'bc039f3d301a4475899cb9e31cb3d953'
    end
    alerted_places.each do |venue|
     Telapi::Message.create( '(716) 341-5129', '(302) 752-4624', "#{venue.name}\n#{venue.location['address']}\n#{venue.location.city}, #{venue.location.state} #{venue.location['postalCode']}\n#{venue.contact['formattedPhone']}" )
    end
  end

end
