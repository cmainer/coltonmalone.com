Rails.application.routes.draw do

  root "pages#index"

  get '/(*path)', :to => "pages#path", :as => :pages, :format => false

end
