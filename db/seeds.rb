User.create!(name:  "Hung Tran",
             email: "hungtran.nh97@gmail.com",
             password:              "hungtran",
             password_confirmation: "hungtran",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
