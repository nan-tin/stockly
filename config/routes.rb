Rails.application.routes.draw do
  get "terms", to: "static_pages#terms"
  get "privacy", to: "static_pages#privacy"
  
  get "settings", to: "settings#index"

  #get "consumptions/index", to: "consumptions#index"

  devise_for :users

  post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  
  root "categories#index"

  resources :categories

  # collection do ... endはIDを必要としない追加アクション
  resources :items do
    collection do
      delete :bulk_destroy
    end

    member do
      patch :consume
      patch :add_to_shopping_item
      patch :increase_quantity
      patch :decrease_quantity
    end
  end

   # member do ... endはIDを必要とする追加アクション
  resources :shopping_items do
    member do
      patch :purchase
    end
  end

  resources :consumptions, only: %i[index new create edit update destroy] do
    collection do
      get :summary_detail
    end
  end

  resources :inquiries, only: %i[new create]
end
