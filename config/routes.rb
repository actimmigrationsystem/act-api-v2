Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Devise routes for authentication under API namespace
  namespace :api do
    namespace :v1 do
      # Default route for /api/v1
      get '/', to: 'base#index'
      get 'enquiries/by_user/:id', to: 'enquiries#show_by_id'
      get 'appointments/by_user/:id', to: 'appointments#show_by_user'
      get 'users/registrations/exists', to: 'registrations#exists'

      # Devise user routes
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }

      devise_scope :api_v1_user do
        get 'users/exists', to: 'users/registrations#exists'
      end

      # Other resources
      resources :enquiries, only: %i[index show create update destroy]
      resources :appointments, only: %i[index show create update destroy]
      resources :profiles, only: %i[index show create update destroy]
    end
  end

  # SuperAdmin namespace
  namespace :super_admin do
    get 'dashboard/index'
  end

  # Admin namespace
  namespace :admin do
    get 'dashboard/index'
  end

  # Client namespace
  namespace :client do
    resources :dashboard, only: %i[index show]
    get 'enquiries/by_user/:id', to: 'enquiries#show_by_id'
  end

  # Root path
  root to: 'rails/welcome#index'

  # Health check route
  get 'up' => 'rails/health#show', as: :rails_health_check
end
