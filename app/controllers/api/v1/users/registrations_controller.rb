module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      respond_to :json

      # Skip authentication for sign-up requests
      # skip_before_action :authenticate_user!, only: [:create]
      skip_before_action :authenticate_user!, only: %i[exists create]

      def exists
        email = params[:email]
        if email.blank?
          render json: { error: 'Email is required' }, status: :bad_request
        else
          exists = User.exists?(email: email)
          render json: { exists: exists }
        end
      end

      def create
        # Check if the email already exists in the database
        if User.exists?(email: sign_up_params[:email])
          render json: { error: 'Email already exists' }, status: :unprocessable_entity
          return
        end

        user = User.new(sign_up_params)

        if user.save
          render json: {
            message: 'User created successfully',
            user: {
              id: user.id,
              email: user.email,
              role: user.role,
              auth_token: SecureRandom.hex(20) # Generate a new auth token
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
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
