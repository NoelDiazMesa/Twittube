namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = Usuario.create!(username:     "Example User",
                          email:    "example@railstutorial.org",
                          password: "foobar",
                          password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    Usuario.create!(username:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = Usuario.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    titulo = " Titulo "
    users.each { |user| user.microposts.create!(content: content, titulo: titulo) }
  end
end

def make_relationships
  users = Usuario.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end