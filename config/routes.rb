Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  resources :videos, only: [:show] do
    collection do
      get 'search'
    end
  end
  resources :categories
end
