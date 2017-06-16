require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of :name }
  it { should validate_length_of(:name).is_at_most(90) }
  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  describe 'crossing_interval scope' do
    let!(:event_in_range1){ create(:event, start_time: '2017-07-01', end_time: '2017-07-19') }
    let!(:event_in_range2){ create(:event, start_time: '2017-05-22', end_time: '2017-06-05') }
    let!(:event_not_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-05-26') }

    it 'should return events which crossing time interval' do
      events = Event.crossing_interval('2017-05-28', '2017-07-08')

      expect(events).to include event_in_range1
      expect(events).to include event_in_range2
      expect(events).to_not include event_not_in_range
    end
  end
end
