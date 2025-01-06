module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      respond_to :json

      # Skip authentication for login and logout requests
      skip_before_action :authenticate_user!, only: %i[create destroy]
      skip_before_action :verify_authenticity_token, only: %i[create destroy]

      def create
        # Authenticate the user using Devise's built-in methods
        self.resource = warden.authenticate!(auth_options)

        if resource
          sign_in(resource_name, resource) # Sign the user in and create a session

          render json: {
            message: 'Logged in successfully.',
            user: {
              id: resource.id,
              email: resource.email,
              role: resource.role
            }
          }, status: :ok
        else
          render json: { error: 'Invalid credentials.' }, status: :unauthorized
        end
      end

      def destroy
        if current_user
          sign_out(resource_name) # Sign out the user and clear the session
          render json: { message: 'Logged out successfully.' }, status: :ok
        else
          render json: { error: 'No user is currently signed in.' }, status: :unauthorized
        end
      end

      private

      # Strong parameters for sign-in
      def sign_in_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
