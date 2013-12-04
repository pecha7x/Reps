class Report
  include Mongoid::Document
  def as_json(options={})
    attrs = super(options)
    attrs["id"] = attrs["_id"]
    attrs
  end

  field :created_at, as: :datetime, type: ActiveSupport::TimeWithZone, default: -> { Time.now.in_time_zone }

  has_many :answers
  belongs_to :user_manager, :class_name => 'User', :inverse_of => :report_manager
  belongs_to :user_employee, :class_name => 'User', :inverse_of => :report_employee

end


