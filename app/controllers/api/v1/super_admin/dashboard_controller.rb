module Api
  module V1
    module SuperAdmin
      class DashboardController < ApplicationController
        before_action :authorize_superadmin

        # Dashboard Index
        def index
          render json: { message: "Welcome to the SuperAdmin Dashboard" }, status: :ok
        end

        # List all users (clients and admins)
        def users
          users = User.select(:id, :email, :role, :created_at, :updated_at).map do |user|
            {
              id: user.id,
              email: user.email,
              role: user.role,
              created_at: user.created_at,
              updated_at: user.updated_at
            }
          end
          render json: users, status: :ok
        end

        # List only clients
        def clients
          clients = User.where(role: "client").select(:id, :email, :created_at, :updated_at)
          render json: clients, status: :ok
        end

        # List only admins
        def admins
          admins = User.where(role: "admin").select(:id, :email, :created_at, :updated_at)
          render json: admins, status: :ok
        end

        private

        # Ensure only superadmin can access these actions
        def authorize_superadmin
          unless current_user&.role == "superadmin"
            render json: { error: "Access denied" }, status: :forbidden
          end
        end
      end
    end
  end
end
