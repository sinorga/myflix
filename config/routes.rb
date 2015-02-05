Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'forgot_password', to: 'forgot_password#new'
  post 'confirm_password_reset', to: 'forgot_password#confirm'
  get 'invalid_token', to: 'pages#invalid_token'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'followees#index'
  get 'invite', to: 'invite_users#new'
  resources :videos, only: [:show] do
    collection do
      get 'search'
    end
    resources :reviews, only: [:create]
    resources :queue_items, only: [:create]
  end
  resources :categories
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:destroy] do
    collection do
      put 'update', action: :update_queue
    end
  end
  resources :followees, only: [:destroy, :create]
  resources :reset_password, only: [:edit, :update]
  resources :invite_users, only: [:create]
end
