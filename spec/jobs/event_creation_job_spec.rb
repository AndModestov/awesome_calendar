require 'rails_helper'

RSpec.describe EventCreationJob, type: :job do
  let(:user){ create(:user) }
  let!(:event) do
    create(:event, user: user,
      start_time: '01-06-2017 20:00 +03:00',
      end_time: '01-06-2017 23:00 +03:00', repeat: 'every day',
      repeat_till_date: '20-06-2017 23:00 +03:00'
    )
  end

  it 'it creates correct repeatable events' do
    expect { EventCreationJob.perform_now(event.id) }.to change(user.events, :count).by(20)
  end

  it 'creates events with right dates' do
    EventCreationJob.perform_now(event.id)
    created_events = Event.order('start_time').limit(20)
    created_events.each_with_index do |event, i|
      next if i == 19
      expect(event.start_time).to eq created_events[i+1].start_time - 1.day
      expect(event.end_time).to eq created_events[i+1].end_time - 1.day
    end
  end
end
