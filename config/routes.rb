Rails.application.routes.draw do
  devise_for :users
  
  root "categories#index"

  resources :categories
  resources :items
  resources :shopping_items
end
