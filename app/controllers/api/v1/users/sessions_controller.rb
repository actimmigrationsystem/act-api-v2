module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      respond_to :json

      # Skip authentication for login (create) requests
      skip_before_action :authenticate_user!, only: [:create]

      def create
        # Log incoming parameters for debugging
        Rails.logger.debug("Params received: #{params.inspect}")

        # Find the user by email
        user = User.find_by(email: sign_in_params[:email])

        if user.nil?
          Rails.logger.debug("User not found for email: #{sign_in_params[:email]}")
          render json: { error: 'Email not found.' }, status: :not_found
          return
        end

        Rails.logger.debug("User found: #{user.inspect}")

        if user.valid_password?(sign_in_params[:password])
          Rails.logger.debug("Password valid for user: #{user.email}")
          user.update(auth_token: SecureRandom.hex(20)) # Generate and update the token
          render json: {
            message: 'Logged in successfully.',
            user: { email: user.email, role: user.role },
            token: user.auth_token
          }, status: :ok
        else
          Rails.logger.debug("Invalid password for user: #{user.email}")
          render json: { error: 'Invalid password.' }, status: :unauthorized
        end
      end

      private

      # Strong parameters for sign_in
      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def respond_to_on_destroy
        if current_user
          render json: { message: 'Logged out successfully.' }, status: :ok
        else
          render json: { error: 'Failed to log out. Please try again.' }, status: :unauthorized
        end
      end
    end
  end
end
