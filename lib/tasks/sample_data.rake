namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = Usuario.create!({ username: "Example User",
                              email: "example@railstutorial.org",
                              password: "foobar",
                              password_confirmation: "foobar",
                              admin: true },  :without_protection => true)
    admin.toggle!(:admin)
    
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      Usuario.create!(username: name,
                      email: email,
                      password: password,
                      password_confirmation: password)
    end

    users = Usuario.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end
end
