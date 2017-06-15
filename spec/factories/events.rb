FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "event#{n}" }
    sequence(:date) { |n| Time.now + n.hours }
  end
end
