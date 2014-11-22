Myflix::Application.routes.draw do
  root 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  resources :videos, only: [:show] do
    collection do
      get 'search'
    end
  end
  resources :categories
  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
