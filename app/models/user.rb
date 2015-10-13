class User < BaseModel
  include Mongoid::Timestamps
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  validate :nickname_validations, presence: true

  field :email, type: String, default: ""
  field :nickname, type: String, default: ""
  field :time_zone, type: String, default: "UTC"
  field :notification_time,  type: Time, default: -> {Time.now - 1.day}
  field :manager, type: Boolean, default: false
  field :status, type: Boolean, default: true
  field :day_of_report, type: Integer, default: 5
  #Time.now.in_time_zone.wday
  field :mood, type: String, default: "Good"
  field :encrypted_password, type: String, default: ""
  field :current_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,       type: Integer, default: 0
  field :current_sign_in_at,  type: Time
  field :last_sign_in_at,     type: Time
  field :current_sign_in_ip,  type: String
  field :last_sign_in_ip,     type: String

  def nickname_validations
    errors.add(:nickname, 'can\'t be empty') if nickname.blank?
    errors.add(:nickname, 'can\'t contain less than 3 symbols') if nickname.size < 3
    nickname = self.nickname.split
    errors.add(:nickname, 'can\'t contain more than 2 words') if nickname.size > 2
    if nickname.size == 2
      errors.add(:nickname, '1 part can\'t contain more than 12 symbols') if nickname[0].size > 12
      errors.add(:nickname, '2 part can\'t contain more than 12 symbols') if nickname[1].size > 12
    elsif nickname.size == 1
      errors.add(:nickname, 'can\'t contain more than 12 symbols') if nickname[0].size > 12
    end
  end

  has_many :report_manager, class_name: 'Report', inverse_of: :user_manager
  has_many :report_employee, class_name: 'Report', inverse_of: :user_employee
end

