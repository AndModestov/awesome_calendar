Rails.application.routes.draw do

  devise_for :users

  resources :events, only: [:show, :index, :create, :update]

  root to: "events#index"
end
