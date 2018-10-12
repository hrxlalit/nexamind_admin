class DistanceSetting
  include Mongoid::Document
  field :distance_range_for_vaildator_of_product_or_store, type: Float
  field :distance_range_for_customer_to_view_store, type: Float

  belongs_to :admin_user

end
