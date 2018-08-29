class ProductRating
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :rate, type: String
  field :review, type: String

  has_many :users, dependent: :destroy
  has_many :products, dependent: :destroy
end
