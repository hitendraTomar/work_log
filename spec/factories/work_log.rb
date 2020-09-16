FactoryBot.define do
  factory :work_log do
    user
    worklog { Faker::Lorem.sentence }
  end
end