class Product
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :name, type: String
  field :cost, type: String
  field :price, type: String
  field :quantity, type: String
  field :sku, type: String
  field :availed_size, type: Array
  field :availed_color, type: Array
  field :description, type: String
  field :category, type: Array
  field :subcategory, type: Array

  belongs_to :store
  has_many :images, as: :imageable, class_name: "Image"
end
