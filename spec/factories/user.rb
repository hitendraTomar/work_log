FactoryBot.define do

  factory :user do
    name         { Faker::Name.unique.name }
    email        { Faker::Internet.email }
    password     {'123456'}
    password_confirmation {'123456'}
  end
end