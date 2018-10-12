class UserWallet
  include Mongoid::Document
  field :ctd, type: float
  field :ctm, type: float
  field :qr_code, type: string
end
