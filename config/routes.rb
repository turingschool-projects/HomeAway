Rails.application.routes.draw do
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :cart_items
  resources :orders, except: [:index]

  resources :items, only: [:index]

  get 'code', to: redirect('https://github.com/larsonkonr/dinner_dash')

  root 'items#index'

  namespace :admin do
    resources :items
    resources :users, only: [:index, :show]
    resources :orders
    resources :categories, only: [:new, :create, :index]
  end
end
