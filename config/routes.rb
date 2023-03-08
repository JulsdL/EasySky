Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :bookings, only: %i[new create]
  get "/objects", to: "celestial_bodies#index", as: :objects
end
