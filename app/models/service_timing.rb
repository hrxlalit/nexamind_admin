class ServiceTiming
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps


  field :day, type: Integer # 0-6, mon-sun
  field :start_time, type: Time
  field :end_time, type: Time
  field :status, type: Mongoid::Boolean, default: false



  belongs_to :store, dependent: :destroy
 # day: [:Sun, :Mon, :Tue, :Wed, :Thu, :Fri, :Sat]
 
end
