class Device
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :device_type, type: String
  field :device_token, type: String

  belongs_to :user, optional: true
  belongs_to :store, optional: true
end
