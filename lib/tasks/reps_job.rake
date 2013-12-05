namespace :reps_job do
  task :weekly_mailing => :environment do
    puts "Check all users and send emails"
    User.all.order_by(created_at: :desk).each do |user|
      puts "####################################"
      puts "Check user #{user.nickname}..."
      puts "####################################"
      if user.status and user.day_of_report == Time.now.wday and user.notification_time < (Time.now.in_time_zone - 1.day)
        user.notification_time =  Time.now
        user.save
        UserMailer.daily(user).deliver
      end
    end
  end
end