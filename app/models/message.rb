class Message
  include Mongoid::Document
  field :sid, type: String
  field :account_sid, type: String
  field :from, type: Integer
  field :status, type: String
  field :direction, type: String
end
