Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'forgot_password', to: 'users#forgot_password'
  post 'confirm_password_reset', to: 'users#confirm_password_reset'
  get 'reset_password/:token', to: 'users#new_reset_password', as: :new_reset_password
  post 'reset_password', to: 'users#reset_password', as: :reset_password
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  get 'people', to: 'followees#index'
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
end
