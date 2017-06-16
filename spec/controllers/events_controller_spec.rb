require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    before { get :index}

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'assigns a new event to @event' do
      expect(assigns(:event)).to be_a_new Event
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

  describe 'POST #create' do

    context 'with valid information' do
      it 'saves the event in database' do
        expect {
          post :create, params: { event: attributes_for(:event) }, format: :js
        }.to change(Event, :count).by(1)
      end

      it 'renders created event json' do
        post :create, params: { event: attributes_for(:event) }, format: :js
        event = Event.last
        resp = JSON.parse(response.body)

        expect(resp['title']).to eq event.name
        expect(resp['start'].to_datetime).to eq event.start_time
        expect(resp['end'].to_datetime).to eq event.end_time
      end
    end

    context 'with invalid information' do
      it 'does not save the event' do
        expect {
          post :create, params: { event: attributes_for(:invalid_event) }, format: :js
        }.to_not change(Event, :count)
      end
    end
  end
end
