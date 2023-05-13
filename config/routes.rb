Rails.application.routes.draw do
  get 'home/page'
  resources :texts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "texts#index"
end
