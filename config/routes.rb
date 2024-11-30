Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Admin namespace
  namespace :admin do
    resources :dashboard, only: [:index]
  end

  # Client namespace
  namespace :client do
    resources :dashboard, only: [:index]
  end

  # API versioning
  namespace :api do
    namespace :v1 do
      resources :enquiries
      resources :appointments
      resources :profiles
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root to: "rails/health#show" # Placeholder, update as needed
end
