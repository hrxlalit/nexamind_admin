class Store
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :name, type: String
  field :store_type, type: String
  field :email, type: String
  field :website, type: String
  field :phone, type: String
  field :address, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :description, type: String

  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :images, as: :imageable, class_name: "Image"
end
