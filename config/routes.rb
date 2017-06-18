Rails.application.routes.draw do

  require 'sidekiq/web'
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  resources :events, only: [:show, :index, :create, :update]

  root to: "events#index"
end
