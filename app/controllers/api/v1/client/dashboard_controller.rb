module Api
  module V1
    module Client
      class DashboardController < ApplicationController
        def index
          render json: { message: "Welcome to the Client Dashboard" }, status: :ok
        end
      end
    end
  end
end