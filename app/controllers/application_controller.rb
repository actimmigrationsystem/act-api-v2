class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Skip CSRF checks for JSON requests
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  before_action :authenticate_user!, unless: -> { request.path.start_with?('/assets', '/public') }
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Allow additional parameters for Devise sign-in and sign-up
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password role])
  end

  # Role-based authorization (optional, depending on your app)
  def authorize_superadmin
    render json: { error: 'Access denied' }, status: :forbidden unless current_user&.role == 'superadmin'
  end

  def authorize_admin
    render json: { error: 'Access denied' }, status: :forbidden unless current_user&.role == 'admin'
  end

  def authorize_client
    render json: { error: 'Access denied' }, status: :forbidden unless current_user&.role == 'client'
  end

  def authorize_admin_or_superadmin
    render json: { error: 'Access denied' }, status: :forbidden unless current_user&.role.in?(%w[admin superadmin])
  end
end
