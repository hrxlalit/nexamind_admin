class Faq
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  field :question, type: String
  field :answer, type: String
end
