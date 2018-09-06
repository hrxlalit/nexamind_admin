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
  field :category, type: String
  field :subcategory, type: String
  field :event_date, type: Date
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :status, type: Integer
  

  belongs_to :store
  has_many :images, as: :imageable, class_name: "Image"
  has_many :product_ratings, dependent: :destroy
  has_many :fav_products, dependent: :destroy
end
