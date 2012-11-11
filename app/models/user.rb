class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :number, type: Integer

  validates_presence_of :name
  validates_presence_of :number
  validates_numericality_of :number

  before_create :remove_dashes
  after_create :send_first_text


  protected

  def remove_dashes
    number = self.number.to_s.gsub(/[^0-9]/, "")
    self.number = number.to_i
  end

  def send_first_text
    Telapi.config do |config|
      config.account_sid = 'ACbbcf2b79541543ff86dd9955952d1076'
      config.auth_token  = 'bc039f3d301a4475899cb9e31cb3d953'
    end
    Telapi::Message.create( "#{number}", '(302) 752-4624', "Thanks for signing up #{name}." )
  end

end
