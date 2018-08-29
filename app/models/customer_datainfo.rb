class CustomerDatainfo
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :level1, type: Mongoid::Boolean
  field :level2, type: Mongoid::Boolean
  field :level3, type: Mongoid::Boolean

  has_many :users, dependent: :destroy
  has_many :store, dependent: :destroy
end
