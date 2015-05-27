Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/wishlist', to: 'favorites#index'

  resources :favorites, only: [:create, :destroy]
  resources :hosts, only: :show
  resources :host_requests, only: [:new, :create, :destroy]

  resources :partners, only: [:create, :destroy]

  get '/my_trip', to: 'cart#show', as: :cart
  delete '/my_trip', to: 'cart#destroy'
  post '/properties/:id/add_to_cart', to: 'cart#update'

  resources :users, except: [:new]
  post '/user/:id/become_host', to: 'users#become_host'

  resources :reservations
  post '/reservations/pay', to: 'reservations#pay'

  get '/my_guests', to: 'reservations#my_guests'

  get '/partner_guests', to: 'reservations#partner_guests'

  resources :properties do
    resources :photos
  end

  get 'code', to: redirect('https://github.com/dalexj/da_pivot')
  root 'pages#home'

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    post 'users/:id/retire', to: 'users#retire', as: :retire_user

    resources :reservations, only: [:index, :update] do
      collection do
        get :pending
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
