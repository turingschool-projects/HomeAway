Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/hosts/:slug', to: 'hosts#show'

  get '/my_trip', to: 'cart#show', as: :cart
  delete '/my_trip', to: 'cart#destroy'
  post '/properties/:id/add_to_cart', to: 'cart#update'

  resources :users

  resources :reservations
  post '/reservations/pay', to: 'reservations#pay'

  get '/my_guests', to: 'reservations#my_guests'

  resources :properties do
    resources :photos
  end

  get 'code', to: redirect('https://github.com/dalexj/da_pivot')
  root 'pages#home'

  namespace :admin do
    resources :users, only: [:index, :show]

    resources :reservations do
      collection do
        get :reserved
        get :cancelled
        get :completed
      end

      member do
        put :complete
        put :cancel
      end
    end

    resources :categories, only: [:new, :create, :index]
  end

end
