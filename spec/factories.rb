# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define do
  factory :usuario do
    sequence(:username)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true 
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    titulo "Lorem ipsum"
    usuario
  end
end