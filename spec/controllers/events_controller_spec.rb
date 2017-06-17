require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  sign_in_user
  let(:other_user) { create(:user) }

  describe 'GET #index' do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'assigns a new event to @event' do
      expect(assigns(:event)).to be_a_new Event
    end
  end


  describe 'GET #index.json' do
    let!(:event_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-06-05', user: other_user) }
    let!(:own_event){ create(:event, start_time: '2017-05-22', end_time: '2017-06-06', user: @user) }
    let!(:event_not_in_range){ create(:event, start_time: '2017-05-22', end_time: '2017-05-26', user: other_user) }

    context 'for all events' do
      before { get :index, format: :json, params: {start: '2017-05-28', end: '2017-07-08'} }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'renders right json events list' do
        expect(response.body).to have_json_size(2)
        expect(response.body).to be_json_eql(EventSerializer.new(event_in_range).to_json).at_path('0')
        expect(response.body).to be_json_eql(EventSerializer.new(own_event).to_json).at_path('1')
      end
    end

    context 'for own events' do
      before { get :index, format: :json, params: {start: '2017-05-28', end: '2017-07-08', for_user: 'true'} }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'renders only own events for user' do
        expect(response.body).to have_json_size(1)
        expect(response.body).to be_json_eql(EventSerializer.new(own_event).to_json).at_path('0')
      end
    end
  end


  describe 'GET #show' do
    let(:event) { create(:event, user: @user) }
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
        }.to change(@user.events, :count).by(1)
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

      it 'returns bad status' do
        post :create, params: { event: attributes_for(:invalid_event) }, format: :js
        expect(response).to_not be_success
      end
    end
  end

  describe 'PATCH #update' do
    let!(:event) { create(:event, user: @user) }
    let!(:other_user_event) { create(:event, user: other_user) }

    context 'update current users event' do
      it 'assigns event to @event' do
        patch :update, params: { id: event, event: attributes_for(:event) }, format: :js
        expect(assigns(:event)).to eq event
      end

      it 'changes event attributes' do
        patch :update, params: { id: event, event: { name: 'new event name' } }, format: :js
        event.reload
        expect(event.name).to eq 'new event name'
      end

      it 'renders updated event' do
        new_params = { name: 'updated name', start_time: '2017-05-22', end_time: '2017-05-24' }
        patch :update, params: { id: event, event: new_params }, format: :js
        resp = JSON.parse(response.body)

        expect(resp['name']).to eq 'updated name'
        expect(resp['formatted_start_time'].to_datetime).to eq '2017-05-22'
        expect(resp['formatted_end_time'].to_datetime).to eq '2017-05-24'
      end
    end

    # context 'update other users event' do
    #   it 'not changes event attributes' do
    #     patch :update, id: other_user_event, event: { name: 'wrong name' }, format: :js
    #     other_user_event.reload
    #     expect(other_user_event.name).to_not eq 'wrong name'
    #   end
    # end
  end
end
