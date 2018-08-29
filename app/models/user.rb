class User
  include ActiveModel::SecurePassword
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  field :name, type: String, default: ''
  field :dob, type: Date
  field :mobile, type: String, default: ''
  field :address, type: String, default: ''
  field :access_token, type: String, default: ''
  field :role, type: String, default: 'user'
  field :status, type: Integer # 0:Dect by admin 1:Active 2:Otp not verified
  field :fb_uid, type: String
  field :google_uid, type: String
  field :gender, type: String

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  has_one :store, dependent: :destroy
  has_one :images, as: :imagable, class_name: "Image"
end
