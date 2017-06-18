FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "event#{n}" }
    sequence(:start_time) { |n| Time.now + n.hours }
    sequence(:end_time) { |n| Time.now + (n+3).hours }
    repeat_till_date Time.now + 5.days
    user nil
  end

  factory :invalid_event, class: 'Event' do
    name nil
    start_time nil
    end_time nil
    user nil
  end
end
