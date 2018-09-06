class ContactU
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :title, type: String
  field :description, type: String
  
  belongs_to :user, optional: true
  belongs_to :store, optional: true
end
