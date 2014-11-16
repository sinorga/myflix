Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'categories#index'
  resources :videos
  resources :categories
end
