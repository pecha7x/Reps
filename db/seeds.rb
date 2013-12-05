#rake db:mongoid:purge
manager = User.create({
                             email: 'js22908@gmail.com',
                             password: '12345678',
                             password_confirmation: '12345678',
                             nickname: 'Jon Smith',
                             manager: true,
                             time_zone: 'London'
                         });

employee = User.create({
                             email: 'artempecherin1@gmail.com',
                             password: '12345678',
                             password_confirmation: '12345678',
                             nickname: 'Zahar Pecherin',
                             manager: false,
                             time_zone: 'Moscow'
                         });
questions = ["What's going well? Any wins (big or little) this week?",
             "What challenges are you facing? Where are you stuck?",
             "How are you feeling? What's the morale you see around you?",
             "One suggestion to improve your role, team or organization?"
]
questions.each do |question|
  Question.create({text: question});
end