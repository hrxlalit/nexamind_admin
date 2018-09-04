class ContactU
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :title, type: String
  field :description, type: String
  
  belongs_to :user
end
