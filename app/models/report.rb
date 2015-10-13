class Report < BaseModel
  field :created_at, as: :datetime, type: ActiveSupport::TimeWithZone, default: -> { Time.now.in_time_zone }

  scope :reports_from_employee, ->(user_id) { where(user_employee_id: user_id).order_by(created_at: :desc)}
  scope :reports_to_manager, ->(user_id) { where(user_manager_id: user_id).order_by(created_at: :desc)}

  has_many :answers
  belongs_to :user_manager, class_name: 'User', inverse_of: :report_manager
  belongs_to :user_employee, class_name: 'User', inverse_of: :report_employee

end


