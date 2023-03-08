Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  get "/objects", to: "celestial_bodies#index", as: :objects
end
