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
  
  field :unique_id, type: String
  field :name, type: String, default: ''
  field :dob, type: Date
  field :mobile, type: String, default: ''
  field :address, type: String, default: ''
  field :access_token, type: String, default: ''
  field :role, type: String, default: 'user'
  field :status, type: Integer # 0:Dect by admin 1:Active 2:Otp not verified
  field :fb_uid, type: String
  field :google_uid, type: String

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

  def self.generate_token user
    access_token = SecureRandom.hex 
    # a = User.exists?(access_token: access_token)
    # unless a.present?
      return access_token
    # end
  end

  # def self.generate_code
  #   binding.pry
  #   unique = SecureRandom.base64(9)
  #   uniq = User.exists?(:unique_id => unique)
  #   unless uniq.present?
  #     return unique_id
  #   end
  # end

  def self.generate_code
    # self.token = loop do
      random_token = SecureRandom.base64(9)
    #   break random_token unless User.exists?(unique_id: random_token)
    # end
    return random_token
  end
end
