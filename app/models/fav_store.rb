class FavStore
  include Mongoid::Document
  field :is_liked, type: Mongoid::Boolean
end
