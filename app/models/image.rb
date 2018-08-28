class Image
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  
  #====================uploader====================
  mount_uploader :file, ImageUploader, :mount_on => :file

  #====================Data field attributes====================
  field :file, type: String
  field :imageable_id, type: String
  field :imageable_type, type: String

  #====================Associations====================
  belongs_to :imagable, polymorphic: true, optional: true

  #====================validation====================
  validates :file, presence: true
end
