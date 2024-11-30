class Api::V1::EnquiriesController < ApplicationController
  before_action :set_enquiry, only: [:show, :update, :destroy]

  # GET /api/v1/enquiries
  def index
    enquiries = Enquiry.all
    render json: enquiries, status: :ok
  end

  # GET /api/v1/enquiries/:id
  def show
    render json: @enquiry, status: :ok
  end

  # POST /api/v1/enquiries
  def create
    enquiry = Enquiry.new(enquiry_params)
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

  # DELETE /api/v1/enquiries/:id
  def destroy
    @enquiry.destroy
    render json: { message: 'Enquiry deleted successfully' }, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_enquiry
    @enquiry = Enquiry.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Enquiry not found' }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def enquiry_params
    params.require(:enquiry).permit(
      :name,
      :surname,
      :phonenumber,
      :email,
      :gender,
      :dob,
      :marital_status,
      :residential_address,
      :entry_date,
      :passport_number,
      :reference_number,
      :service_type,
      :elaborate,
      :immigration_status
    )
  end
end
