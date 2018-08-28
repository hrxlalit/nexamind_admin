class CustomerDatainfo
  include Mongoid::Document
  field :level1, type: Mongoid::Boolean
  field :level2, type: Mongoid::Boolean
  field :level3, type: Mongoid::Boolean
end
