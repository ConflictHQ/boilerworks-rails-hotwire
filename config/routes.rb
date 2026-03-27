Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  get "dashboard", to: "dashboard#index"
  resources :products
  resources :categories

  root "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
