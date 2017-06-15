FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@email.ru" }
    sequence(:name) { |n| "user#{n}" }
    password 123456
    password_confirmation 123456
  end
end
