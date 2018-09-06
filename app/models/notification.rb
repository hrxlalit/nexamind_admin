class Notification
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  field :notifiable_id, type: String
  field :notifiable_type, type: String
  field :title, type: String
  field :content, type: String
  field :status, type: Mongoid::Boolean, default: false
  field :notification_type, type: String
  

  belongs_to :notifiable, polymorphic: true
  belongs_to :user
  belongs_to :store
end
