Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  get "dashboard", to: "dashboard#index"
  resources :items
  resources :categories
  resources :workflow_definitions
  resources :workflow_instances do
    member do
      post :transition
    end
  end

  resources :form_definitions do
    member do
      post :publish
      post :archive
    end
  end

  resources :form_submissions, only: [:index, :show, :new, :create] do
    member do
      post :approve
      post :reject
    end
  end

  root "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
