Rails.application.routes.draw do
  devise_for :users

  root 'stories#index'

  resources :stories do
    member do
      post :start
      post :subscribe
      match :unsubscribe, via: [:get, :post]
      get :is_active
      get :chat
    end
    resources :sentences do
      member do
        post :vote
      end
    end
  end

  resources :users, only: :show
end
