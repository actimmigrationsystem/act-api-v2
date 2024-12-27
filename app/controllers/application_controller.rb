class ApplicationController < ActionController::API
  before_action :authenticate_user!, unless: -> { request.path.start_with?('/assets', '/public') }

  private

  def current_user
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    @current_user ||= User.find_by(auth_token: token) if token
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.debug "Authorization Header: #{request.headers['Authorization']}"
    Rails.logger.debug "Extracted Token: #{token}"

    if token.blank?
      Rails.logger.debug 'No token provided in the Authorization header.'
      return render json: { error: 'Unauthorized: Missing Token' }, status: :unauthorized
    end

    @current_user = User.find_by(auth_token: token)

    if @current_user
      Rails.logger.debug "User found: #{@current_user.inspect}"
    else
      Rails.logger.debug "User not found for token: #{token}"
      render json: { error: 'Unauthorized: Invalid Token' }, status: :unauthorized
    end
  end

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
