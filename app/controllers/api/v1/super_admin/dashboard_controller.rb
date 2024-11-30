module Api
  module V1
    module SuperAdmin
      class DashboardController < ApplicationController
        def index
          render json: { message: "Welcome to the SuperAdmin Dashboard" }, status: :ok
        end
      end
    end
  end
end