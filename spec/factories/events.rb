FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "event#{n}" }
    sequence(:start_time) { |n| Time.now + n.hours }
    sequence(:end_time) { |n| Time.now + (n+3).hours  }
  end

  factory :invalid_event, class: 'Event' do
    sequence(:name) { |n| "event#{n}" }
    start_time nil
    end_time nil
  end
end
