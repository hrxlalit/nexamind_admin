class StaticPage
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :title, type: String
  field :description, type: String
end
