# app/controllers/enquiries_controller.rb
class EnquiriesController < ApplicationController
  before_action :set_enquiry, only: %i[show update destroy]

  # GET /enquiries
  def index
    @enquiries = Enquiry.all
    render json: @enquiries, status: :ok
  end

  # GET /enquiries/:id
  def show
    render json: {
      enquiry: @enquiry,
      document_url: @enquiry.document_upload.attached? ? url_for(@enquiry.document_upload) : nil
    }, status: :ok
  end

  # POST /enquiries
  def create
    @enquiry = Enquiry.new(enquiry_params)

    if @enquiry.save
      render json: @enquiry, status: :created
    else
      render json: { errors: @enquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /enquiries/:id
  def update
    if @enquiry.update(enquiry_params)
      render json: @enquiry, status: :ok
    else
      render json: { errors: @enquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /enquiries/:id
  def destroy
    @enquiry.destroy
    head :no_content
  end

  private

  def set_enquiry
    @enquiry = Enquiry.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Enquiry not found" }, status: :not_found
  end

  def enquiry_params
    params.require(:enquiry).permit(
      :name, :surname, :phonenumber, :email, :gender, :dob, :marital_status,
      :residential_address, :immigration_status, :entry_date, :passport_number,
      :reference_number, :service_type, :elaborate, :document_upload
    )
  end
end
