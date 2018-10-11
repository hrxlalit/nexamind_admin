require "twilio"
class User
  include ActiveModel::SecurePassword
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid
  include TwilioSms
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""
  
  field :unique_id, type: String, default: ''
  field :name, type: String, default: ''
  field :dob, type: Date
  field :code, type: String, default: ''
  field :mobile, type: String, default: ''
  field :gender, type: Integer #0:male  1:female
  field :address, type: String, default: ''
  field :coordinates, :type => Array
  field :otp, type: String
  field :otp_gen_time, type: DateTime
  field :access_token, type: String, default: ''
  field :role, type: String, default: 'user'
  field :status, type: Integer, default: 2 # 0:Dect by admin 1:Active 2:Otp not verified
  field :admin_approved, type: Integer, default: 0 # 0:rejected 1:Approved
  field :max_behaviour, type: Integer, default: 0 
  field :min_behaviour, type: Integer, default: 0 
  field :touch_id, type: Mongoid::Boolean, default: false
  field :fb_uid, type: String
  field :google_uid, type: String
  field :gender, type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String
  

  has_many :devices, dependent: :destroy
  has_one :store, dependent: :destroy
  has_one :image, as: :imageable, class_name: "Image"
  has_many :user_docs, dependent: :destroy
  has_many :fav_stores, dependent: :destroy
  has_many :product_ratings, dependent: :destroy
  has_many :fav_products, dependent: :destroy
  has_many :contact_u, dependent: :destroy
 
  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  def self.generate_token
    access_token = SecureRandom.hex 
    generate_token if User.where(access_token: access_token).exists? || Store.where(access_token: access_token).exists?
    return access_token
  end

  def self.generate_code
    unique_id = SecureRandom.base64(9)
    generate_code if User.where(unique_id: unique_id).exists? || Store.where(unique_id: unique_id).exists?
    return unique_id
  end

  def self.generate_otp_and_send mobile, code, user
    mobile_no = code + mobile
    otp = [*1000..9999].sample
    # otp =  "1234"
    user.update_attributes(otp: otp, otp_gen_time: DateTime.current)
    TwilioSms.send_otp(mobile_no, "Your Centrium App account OTP is: #{otp}" )
  end

  def self.generate_otp_and_send_mailer user
    otp = rand(1111..9999)
    user.update_attributes(otp: otp, otp_gen_time: DateTime.current)
    msg = "#{otp} is your one time password(OTP). This is usable once & valid for 15 minuts from request. Do not share with anyone."
    UserMailer.send_otp(user, msg).deliver_now
  end

  def otp_expired?
    otp_gen_time < 15.minutes.ago
  end
end
