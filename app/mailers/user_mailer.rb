class UserMailer < ActionMailer::Base
  default from: "no-reply@weeklyreps.com"
  def weekly(user)
    @user = user
    mail to: @user.email, subject: "WeeklyReps: weekly notification.", template_path: 'notifications', template_name: 'weekly'
  end

  def invite(user_from, email_to)
    @user = user_from
    mail to: email_to, subject: "WeeklyReps: invitation.", template_path: 'notifications', template_name: 'invite'
  end

  def report(report)
    @report = report
    mail to: @report.user_manager.email, subject: "WeeklyReps: new report.", template_path: 'notifications', template_name: 'report'
  end
end