class UserMailer < ActionMailer::Base
  default from: "no-reply@weeklyreps.com"
  def weekly(user)
    @user = user
    mail to: @user.email, subject: "WeeklyReps", template_path: 'notifications', template_name: 'weekly'
  end

  def intive(user_from, email_to)
    @user = user_from
    mail to: email_to, subject: "WeeklyReps", template_path: 'notifications', template_name: 'intive'
  end

  def report(report)
    @report = report
    mail to: @report.user_manager.email, subject: "WeeklyReps", template_path: 'notifications', template_name: 'report'
  end
end