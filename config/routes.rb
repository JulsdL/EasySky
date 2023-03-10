Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "/mes-réservations", to: "bookings#index", as: :mes_reservations
  get "/bookings/:id/checkout/paiement", to: "bookings#paiement", as: :paiement
  get "users/dashboard", to: "pages#dashboard"
  get "users/informations", to: "pages#informations"
  resources :bookings, only: %i[new create show] do
    member do
      get :checkout
    end
  end
  get "/objects", to: "celestial_bodies#index", as: :objects

  resources :observation_plannings, only: %i[index show]
end
