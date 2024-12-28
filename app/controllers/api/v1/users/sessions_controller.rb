module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      respond_to :json

      # Skip authentication for login requests
      skip_before_action :authenticate_user!, only: [:create]
      def create
        # Find user by email
        user = User.find_by(email: sign_in_params[:email])

        if user.nil?
          render json: { error: 'Email not found.' }, status: :not_found
          return
        end

        if user.valid_password?(sign_in_params[:password])
          # Generate a new token and update the user
          token = SecureRandom.hex(20)
          user.update(auth_token: token)

          # Respond with user details and the token
          render json: {
            message: 'Logged in successfully.',
            user: {
              id: user.id,
              email: user.email,
              role: user.role,
              auth_token: token # Return the token
            }
          }, status: :ok
        else
          # Invalid password
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
          # Clear token on logout (optional)
          current_user.update(auth_token: nil)
          render json: { message: 'Logged out successfully.' }, status: :ok
        else
          render json: { error: 'Failed to log out. Please try again.' }, status: :unauthorized
        end
      end
    end
  end
end
