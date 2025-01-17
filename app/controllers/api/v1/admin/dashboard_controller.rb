module Api
  module V1
    module Admin
      class DashboardController < ApplicationController
        def index
          render json: { message: "Welcome to the Admin Dashboard" }, status: :ok
        end
            # List only clients
        def clients
          clients = User.where(role: "client").select(:id, :email, :created_at, :updated_at)
          render json: clients, status: :ok
        end
      end
    end
  end
end
