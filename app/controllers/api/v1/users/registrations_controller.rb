module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      respond_to :json

      # Skip authentication for sign-up requests
      skip_before_action :authenticate_user!, only: [:create]

      def create
        user = User.new(sign_up_params)

        if user.save
          render json: { message: 'User registered successfully.', user: user }, status: :created
        else
          render json: { error: 'Registration failed.', details: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      # Strong parameters for sign-up
      def sign_up_params
        params.require(:user).permit(:email, :password, :role)
      end
    end
  end
end
