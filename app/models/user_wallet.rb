class UserWallet
  include Mongoid::Document
  field :ctd, type: Float
  field :ctm, type: Float
  field :qr_code, type: String
  belongs_to :user
end
