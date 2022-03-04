Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'listings/index'
      get 'listings/show'
    end
  end
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :listings, only: [:index, :show, :create, :update, :destroy]
      resources :bookings, only: [:index, :show, :create, :update, :destroy]
      resources :reservations, only: [:index, :show, :create, :update, :destroy]
      resources :missions, only: [:index, :create,]
    end
  end
end
