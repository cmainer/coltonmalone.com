Rails.application.routes.draw do

  resources :posts

	#Casein routes
	namespace :casein do
		resources :posts
	end

  root "static_pages#index"
end
