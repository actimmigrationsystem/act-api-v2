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
    Rails.logger.info "Authorization Header: #{request.headers['Authorization']}"

    # Use the authenticated user
    if current_user
      Rails.logger.info "Current User: #{current_user.inspect}"

      if current_user.role == 'superadmin'
        # Superadmin can view all users' enquiries
        target_user = User.find_by(id: params[:id])
        if target_user
          render json: target_user.enquiries, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      elsif current_user.role == 'admin'
        # Admins can view a subset of enquiries
        target_user = User.find_by(id: params[:id])
        if target_user
          render json: target_user.enquiries.limit(10), status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      elsif current_user.role == 'client'
        # Clients can only view their own enquiries
        render json: current_user.enquiries, status: :ok
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
