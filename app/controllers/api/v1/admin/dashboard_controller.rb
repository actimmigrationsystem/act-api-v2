module Api
  module V1
    module Admin
      class DashboardController < ApplicationController
        def index
          render json: { message: "Welcome to the Admin Dashboard" }, status: :ok
        end
      end
    end
  end
end
