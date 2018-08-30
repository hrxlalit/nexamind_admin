class UserDoc
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  # mount_uploader :front_img, ImageUploader, :mount_on => :file
  # mount_uploader :back_img, ImageUploader, :mount_on => :file

  field :doc_no, type: String
  field :doc_type, type: String
  field :front_img, type: String
  field :back_img, type: String

  belongs_to :user
end
