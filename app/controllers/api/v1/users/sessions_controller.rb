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
          render json: { error: 'Email not found.' }, status: :not_found
          return
        end

        if user.valid_password?(sign_in_params[:password])
          user.update(auth_token: SecureRandom.hex(20)) # Generate and update the token
          render json: { 
            message: 'Logged in successfully.', 
            user: user, 
            token: user.auth_token 
          }, status: :ok
        else
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
