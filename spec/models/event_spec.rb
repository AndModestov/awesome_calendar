require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(90) }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }
  it { should validate_presence_of :user_id }
  it { should belong_to :user }

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

  describe 'serialize method' do
    let!(:user){ create(:user) }
    let!(:event){ create(:event, user: user) }

    it 'serializes event' do
      target_hash = {
        title: event.name, description: '', start: event.start_time.localtime,
        end: event.end_time.localtime, url: event.url
      }

      expect(event.serialize).to eq target_hash
    end
  end

  describe 'crossing_interval class method' do
    let(:user) { create(:user) }
    let!(:event_in_range1) { create(:event, start_time: '2017-07-01', end_time: '2017-07-19', user: user) }
    let!(:event_in_range2) { create(:event, start_time: '2017-05-22', end_time: '2017-06-05', user: user) }
    let!(:event_not_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-05-26', user: user) }
    let(:repeating_event){ create(:event, start_time: '2017-04-22', end_time: '2017-04-23', user: user, repeat: 'every month') }

    it 'should return all non-repeating events which crossing time interval' do
      events = Event.crossing_interval('2017-05-28', '2017-07-08', nil)

      expect(events).to include event_in_range1.serialize
      expect(events).to include event_in_range2.serialize
      expect(events).to_not include event_not_in_range.serialize
    end

    it 'should also return repeating events which crossing time interval' do
      serialized_event = repeating_event.serialize
      serialized_event[:start] +=  2.month
      serialized_event[:end] += 2.month

      events = Event.crossing_interval('2017-05-28', '2017-07-08', nil)

      expect(events).to include serialized_event
    end
  end

  describe 'dates_in_interval method' do
    let(:user) { create(:user) }
    let(:everyday_event) { create(:event, start_time: '2017-04-22', end_time: '2017-04-23', user: user, repeat: 'every day') }
    let(:everyweek_event) { create(:event, start_time: '2017-04-22', end_time: '2017-04-23', user: user, repeat: 'every week') }
    let(:everymonth_event) { create(:event, start_time: '2017-04-22', end_time: '2017-04-23', user: user, repeat: 'every month') }
    let(:everyyear_event) { create(:event, start_time: '2017-04-22', end_time: '2017-04-23', user: user, repeat: 'every year') }
    let(:start_time) { '2017-07-22'.to_datetime }
    let(:end_time) { '2017-08-28'.to_datetime }

    it 'returns repeat dates for every day event' do
      dates = everyday_event.dates_in_interval(start_time, end_time)
      expect(dates).to eq (start_time..end_time).to_a
    end

    it 'returns repeat dates for every week event' do
      dates = everyweek_event.dates_in_interval(start_time, end_time)
      expect(dates).to eq (start_time..end_time).group_by(&:wday)[6]
    end

    it 'returns repeat dates for every month event' do
      dates = everymonth_event.dates_in_interval(start_time, end_time)
      expect(dates).to eq (start_time..end_time).group_by(&:day)[22]
    end

    it 'returns repeat dates for every year event' do
      start_time = '2017-03-22'.to_datetime
      end_time = '2017-04-28'.to_datetime
      dates = everyyear_event.dates_in_interval(start_time, end_time)
      expect(dates).to eq (start_time..end_time).group_by(&:month)[4].group_by(&:day)[22]
    end
  end

  describe 'all_repeats_in_dates method' do
    let(:user) { create(:user) }
    let(:event) { create(:event, start_time: '2017-04-22', end_time: '2017-04-23', user: user) }

    it 'returns serialized events for each provided date' do
      dates = (Time.now.to_date..Time.now.to_date + 3.days).to_a
      repeats = event.all_repeats_in_dates(dates)

      dates.each_with_index do |date, i|
        expected_start_time = ( date.strftime('%e-%m-%Y') + " " + event.start_time.strftime('%H:%M %z') ).to_time
        expected_end_time = expected_start_time + (event.end_time - event.start_time)

        expect(repeats[i][:start]).to eq expected_start_time
        expect(repeats[i][:end]).to eq expected_end_time
      end
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
