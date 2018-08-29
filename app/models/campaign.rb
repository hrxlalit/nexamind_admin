class Campaign
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :name, type: String
  field :start_date, type: String
  field :end_date, type: String
  field :quantity, type: String
  field :discount, type: String

  belongs_to :store
end
