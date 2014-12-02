Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  resources :videos, only: [:show] do
    collection do
      get 'search'
    end
    resources :reviews, only: [:create]
    resources :queue_items, only: [:create]
  end
  resources :categories
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:destroy]
end
