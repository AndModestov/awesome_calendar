require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    before { get :index}

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #index json' do
    let!(:event_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-06-05') }
    let!(:event_not_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-05-26') }
    before { get :index, format: :json, params: {start: '2017-05-28', end: '2017-07-08'} }

    it 'returns 200 status' do
      expect(response).to be_success
    end

    it 'renders right json events list' do
      expect(response.body).to have_json_size(1)
      expect(response.body).to be_json_eql(EventSerializer.new(event_in_range).to_json).at_path('0')
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event) }
    before { get :show, params: {id: event} }

    it 'assigns the requested event to @event' do
      expect(assigns(:event)).to eq event
    end

    it 'should render the show view' do
      expect(response).to render_template :show
    end
  end
end
