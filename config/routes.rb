Rails.application.routes.draw do
  resources :posts

  root "static_pages#index"
end
