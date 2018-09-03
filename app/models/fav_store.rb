class FavStore
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  field :is_liked, type: Mongoid::Boolean

  belongs_to :user
  belongs_to :store
end
