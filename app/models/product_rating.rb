class ProductRating
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :rate, type: String
  field :review, type: String

  belongs_to :product, dependent: :destroy
  belongs_to :user, dependent: :destroy
end
