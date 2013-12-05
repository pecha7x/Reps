class UserMailer < ActionMailer::Base
  default from: "no-reply@weeklyreps.com"
  def weekly(user)
    @user = user
    mail to: @user.email, subject: "WeeklyReps", template_path: 'notifications', template_name: 'weekly'
  end

  def intive(email)
    mail to: email, subject: "WeeklyReps", template_path: 'notifications', template_name: 'intive'
  end

  def report(user)
    mail to: user.email, subject: "WeeklyReps", template_path: 'notifications', template_name: 'report'
  end
end