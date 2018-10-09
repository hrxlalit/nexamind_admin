class Store
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  include Geocoder::Model::Mongoid

  has_secure_password
  geocoded_by :coordinates
  # after_validation :geocode, :if => :location_changed?
  
  index({ coordinates: "2d" },  { min: -180, max: 180 })



  field :name, type: String
  field :store_type, type: Integer# 0:cloths 1:food and beverages 2:entertainment 3:events 5:gadgets
  field :email, type: String, default: ''
  field :password_digest, :type => String
  field :website, type: String
  field :code, type: String
  field :mobile, type: String, default: ''
  field :address, type: String
  field :location, type: String
  field :coordinates, :type => Array
  field :description, type: String
  field :unique_id, type: String, default: ''
  field :touch_id, type: Mongoid::Boolean, default: false
  field :otp, type: String
  field :otp_gen_time, type: DateTime
  field :access_token, type: String, default: ''
  field :status, type: Integer, default: 2 # 0:Dect by admin 1:Active 2:Otp not verified
  field :is_verified, type: Mongoid::Boolean, default: false

  has_many :products, dependent: :destroy
  has_many :images, as: :imageable, class_name: "Image"
  has_many :devices, dependent: :destroy
  has_many :ratings, dependent: :destroy, class_name: "StoreRating"
  has_many :fav_stores, dependent: :destroy
  has_many :service_timings, dependent: :destroy
  has_many :user_docs, dependent: :destroy
  has_many :campaigns, dependent: :destroy
  accepts_nested_attributes_for :service_timings , :allow_destroy => true, :reject_if =>:all_blank
  
  def self.generate_otp_and_send store
    otp = rand(1111..9999)
    store.update_attributes(otp: otp, otp_gen_time: DateTime.current)
    msg = "#{otp} is your one time password(OTP). This is usable once & valid for 15 minuts from request. Do not share with anyone."
    UserMailer.send_otp(store, msg).deliver_now
  end

  def self.forgot_generate_otp_and_send mobile, code, store
    mobile_no = code + mobile
    otp = [*1000..9999].sample
    # otp =  "1234"
    store.update_attributes(otp: otp, otp_gen_time: DateTime.current)
    # TwilioSms.send_otp(mobile_no, "Your Centrium App account OTP is: #{@otp}" )
  end

  def otp_expired?
    otp_gen_time < 15.minutes.ago
  end

  # def self.at_range(latitude, longitude, range)
  #   geo_near([latitude, longitude]).max_distance(range.fdiv(111.12))
  # end

  # def latitude
  #   coordinates[0]
  # end

  # def longitude
  #   coordinates[1]
  # end
end
