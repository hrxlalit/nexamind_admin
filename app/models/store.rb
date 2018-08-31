class Store
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps

  include ActiveModel::SecurePassword

  has_secure_password

  field :name, type: String
  field :store_type, type: String
  field :email, type: String, default: ''
  field :password_digest, :type => String
  field :website, type: String
  field :code, type: String
  field :mobile, type: String, default: ''
  field :address, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :description, type: String
  field :unique_id, type: String, default: ''
  field :touch_id, type: Boolean, default: false
  field :otp, type: String
  field :otp_gen_time, type: DateTime
  field :access_token, type: String, default: ''
  field :status, type: Integer # 0:Dect by admin 1:Active 2:Otp not verified

  has_many :products, dependent: :destroy
  has_many :images, as: :imageable, class_name: "Image"

  def self.generate_otp_and_send store
    otp = rand(1111..9999)
    store.update_attributes(otp: otp, otp_gen_time: DateTime.current)
    msg = "#{otp} is your one time password(OTP). This is usable once & valid for 15 minuts from request. Do not share with anyone."
    UserMailer.send_otp(store, msg).deliver_now
  end

  def otp_expired?
    otp_gen_time < 15.minutes.ago
  end
end
