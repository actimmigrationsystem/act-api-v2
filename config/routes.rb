Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Devise routes for authentication under API namespace
  namespace :api do
    namespace :v1 do
      # Default route for /api/v1
      get '/', to: 'base#index'

      # Devise user routes
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }

      # Other resources
      resources :enquiries, only: [:index, :show, :create, :update, :destroy]
      resources :appointments, only: [:index, :show, :create, :update, :destroy]
      resources :profiles, only: [:index, :show, :create, :update, :destroy]
    end
  end

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

  # Root path
  root to: "rails/welcome#index"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
