Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # SuperAdmin namespace
  namespace :super_admin do
    get "dashboard/index"
  end

  # Admin namespace
  namespace :admin do
    get "dashboard/index"
    resources :dashboard, only: [:index]
  end

  # Client namespace
  namespace :client do
    resources :dashboard, only: [:index]
  end

  # API versioning
  namespace :api do
    namespace :v1 do
      resources :enquiries, only: [:index, :show, :create, :update, :destroy]
      resources :appointments, only: [:index, :show, :create, :update, :destroy]
      resources :profiles, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # Root path for Rails welcome page
  root to: "rails/welcome#index"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
