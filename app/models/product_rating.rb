class ProductRating
  include Mongoid::Document
  field :rate, type: String
  field :review, type: String
end
