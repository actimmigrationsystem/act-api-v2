class Api::V1::EnquiriesController < ApplicationController
  before_action :authenticate_user! # Authenticate all actions
  before_action :set_enquiry, only: %i[show update destroy]

  # GET /api/v1/enquiries
  def index
    enquiries = current_user.enquiries # Only return enquiries belonging to the current user
    render json: enquiries, status: :ok
  end

  # GET /api/v1/enquiries/:id
  def show
    @enquiries = current_user.enquiries
    render json: @enquiries
  end

  # POST /api/v1/enquiries
  def create
    enquiry = current_user.enquiries.build(enquiry_params) # Associate enquiry with the logged-in user
    if enquiry.save
      render json: enquiry, status: :created
    else
      render json: { errors: enquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/enquiries/:id
  # PATCH /api/v1/enquiries/:id
  def update
    if @enquiry.update(enquiry_params)
      render json: @enquiry, status: :ok
    else
      render json: { errors: @enquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show_by_id
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.info "Authorization Header: #{request.headers['Authorization']}"
    Rails.logger.info "Extracted Token: #{token}"

    @current_user = User.find_by(auth_token: token)
    Rails.logger.info "User Found: #{@current_user.inspect}"

    user = User.find_by(id: params[:id])
    Rails.logger.info "Target User: #{user.inspect}"

    if @current_user
      # Role-based access logic
      if @current_user.role == 'superadmin'
        # Superadmin can fetch all enquiries of any user
        enquiries = user&.enquiries
        render json: enquiries || { error: 'User not found' }, status: :ok
      elsif @current_user.role == 'admin'
        # Admin can view enquiries, but maybe only a subset (e.g., limited)
        enquiries = user&.enquiries&.limit(10)
        render json: enquiries || { error: 'User not found' }, status: :ok
      elsif @current_user.role == 'client' && user == @current_user
        # Client can only fetch their own enquiries
        enquiries = @current_user.enquiries
        render json: enquiries, status: :ok
      else
        render json: { error: 'Unauthorized access' }, status: :forbidden
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # DELETE /api/v1/enquiries/:id
  def destroy
    @enquiry.destroy
    render json: { message: 'Enquiry deleted successfully' }, status: :ok
  end

  private

  def set_enquiry
    @enquiry = current_user.enquiries.find(params[:id]) # Ensure the enquiry belongs to the current user
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Enquiry not found' }, status: :not_found
  end

  def enquiry_params
    params.require(:enquiry).permit(
      :name, :surname, :phonenumber, :email, :gender, :dob,
      :marital_status, :residential_address, :entry_date,
      :passport_number, :reference_number, :service_type,
      :elaborate, :immigration_status
    )
  end
end
