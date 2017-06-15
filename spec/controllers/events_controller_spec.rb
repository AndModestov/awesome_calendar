require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  sign_in_user

  describe 'GET #index' do
    let(:events){ create_list(:event, 2) }
    before { get :index}

    it 'assigns a @event list' do
      expect(assigns(:events)).to eq events
    end

    it 'renders index view' do
      expect(response).to render_template :index
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
