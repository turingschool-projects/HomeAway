Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'



  resources :users
  resources :cart_properties

  resources :reservations

  resources :properties, only: [:index, :show]

  get 'code', to: redirect('https://github.com/larsonkonr/dinner_dash')
  root 'properties#index'

  namespace :admin do
    resources :properties
    resources :users, only: [:index, :show]

    resources :reservations do
      collection do
        get :reserved
        get :cancelled
        get :paid
        get :completed
      end

      member do
        put :pay
        put :complete
        put :cancel
      end
    end

    resources :categories, only: [:new, :create, :index]
  end

end
