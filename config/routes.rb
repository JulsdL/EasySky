Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

<<<<<<< HEAD
  resources :bookings, only: %i[new create]
  get "/mes-réservations", to: "bookings#index", as: :mes_reservations
=======
  resources :bookings, only: %i[new create show] do
    member do
      get :checkout
    end
  end
>>>>>>> de35e278598771b311acba4a41aacf51c7f6d746
  get "/objects", to: "celestial_bodies#index", as: :objects
end
