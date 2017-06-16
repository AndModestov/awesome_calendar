Rails.application.routes.draw do

  devise_for :users

  resources :users, only: [:show]
  resources :events, only: [:show, :index, :create, :update]

  root to: "events#index"
end
