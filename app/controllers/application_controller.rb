class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def current_user
    @current_user ||= User.find_by(auth_token: request.headers["Authorization"])
  end

  def authenticate_user!
    render json: { error: "Unauthorized" }, status: :unauthorized unless current_user
  end

  def authorize_superadmin
    render json: { error: "Access denied" }, status: :forbidden unless current_user&.role == "superadmin"
  end

  def authorize_admin
    render json: { error: "Access denied" }, status: :forbidden unless current_user&.role == "admin"
  end

  def authorize_client
    render json: { error: "Access denied" }, status: :forbidden unless current_user&.role == "client"
  end

  def authorize_admin_or_superadmin
    render json: { error: "Access denied" }, status: :forbidden unless current_user&.role.in?(%w[admin superadmin])
  end
end
