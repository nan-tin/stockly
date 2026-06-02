Rails.application.routes.draw do
  devise_for :users
  
  root "categories#index"

  resources :categories

  # collection do ... endはIDを必要としない追加アクション
  resources :items do
    collection do
      delete :bulk_destroy
    end
  end

   # member do ... endはIDを必要とする追加アクション
  resources :shopping_items do
    member do
      patch :purchase
    end
  end
end
