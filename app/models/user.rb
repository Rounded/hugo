class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :number

  validates_presence_of :name
  validates_presence_of :number

  before_create :remove_dashes
  after_create :send_first_text


  protected

  def remove_dashes
    self.number = self.number.to_s.gsub(/[^0-9]/, "")
  end

  def send_first_text
    
  end

end
