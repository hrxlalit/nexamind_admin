class ProductRating
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :rate, type: Float
  field :review, type: String

  belongs_to :user
  belongs_to :product
end
