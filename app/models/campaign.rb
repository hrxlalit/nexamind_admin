class Campaign
  include Mongoid::Document
  field :name, type: String
  field :start_date, type: String
  field :end_date, type: String
  field :quantity, type: String
  field :discount, type: String
end
