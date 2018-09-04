class Token
  include Mongoid::Document
  field :per_token_price, type: String
  field :adding_product_price, type: String
end
