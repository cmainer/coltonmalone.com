Rails.application.routes.draw do

  resources :posts

	#Casein routes
	namespace :casein do
		resources :posts
	end

  root "static_pages#index"

  post '/contact', :to => "static_pages#contactme", as: :contact_me

  get '/(*path)', :to => "static_pages#path", :as => :pages, :format => false

end
