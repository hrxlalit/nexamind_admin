class ServiceTiming
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps


  field :day, type: Integer
  field :start_time, type: Time
  field :end_time, type: Time
  field :status, type: Boolean, default: false



  belongs_to :store, dependent: :destroy
 # day: [:Sun, :Mon, :Tue, :Wed, :Thu, :Fri, :Sat]
 
end
