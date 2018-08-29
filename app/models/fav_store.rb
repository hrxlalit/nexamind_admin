class FavStore
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :is_liked, type: Mongoid::Boolean

  has_many :users, dependent: :destroy
  has_many :stores, dependent: :destroy
end
