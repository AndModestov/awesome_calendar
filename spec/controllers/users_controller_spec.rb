require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  sign_in_user

  describe 'GET #show' do
    before { get :show, params: {id: @user} }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq @user
    end

    it 'should render the show view' do
      expect(response).to render_template :show
    end
  end
end
