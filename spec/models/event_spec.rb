require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(90) }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }

  describe 'crossing_interval scope' do
    let(:user) { create(:user) }
    let!(:event_in_range1){ create(:event, start_time: '2017-07-01', end_time: '2017-07-19', user: user) }
    let!(:event_in_range2){ create(:event, start_time: '2017-05-22', end_time: '2017-06-05', user: user) }
    let!(:event_not_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-05-26', user: user) }

    it 'should return events which crossing time interval' do
      events = Event.crossing_interval('2017-05-28', '2017-07-08')

      expect(events).to include event_in_range1
      expect(events).to include event_in_range2
      expect(events).to_not include event_not_in_range
    end
  end

  describe 'for_user scope' do
    let!(:user){ create(:user) }
    let!(:user2){ create(:user) }
    let!(:event){ create(:event, user: user) }
    let!(:event2){ create(:event, user: user2) }

    it 'should return events only for user' do
      events = Event.for_user(user.id)

      expect(events).to include event
      expect(events).to_not include event2
    end
  end

  describe 'repeat_time_offset method' do
    let(:user){ create(:user) }
    let!(:event1){ create(:event, user: user, repeat: 'every day') }
    let!(:event2){ create(:event, user: user, repeat: 'every week') }
    let!(:event3){ create(:event, user: user, repeat: 'every month') }


    it 'should return right time offset' do
      expect(event1.repeat_time_offset).to eq 1.day
      expect(event2.repeat_time_offset).to eq 1.week
      expect(event3.repeat_time_offset).to eq 1.month
    end
  end

  describe 'cant_ends_earlier_than_starts validator' do
    let(:user){ create(:user) }
    let!(:event) { Event.new(user: user, name: 'name', start_time: Time.now, end_time: Time.now-1.hour) }

    it 'should not be valid if end_time earlier than start' do
      expect(event).to_not be_valid
      expect(event.errors.full_messages).to eq ["End time cant't be lower than start"]
    end
  end
end
