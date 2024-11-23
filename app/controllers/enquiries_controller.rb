class EnquiriesController < ApplicationController
    before_action :set_enquiry, only: %i[show update destroy]

  def index
    @enquiries = Enquiry.all
    render json: @enquiries
  end

  def show
    render json: @enquiry
  end

  def create
    @enquiry = Enquiry.new(enquiry_params)
    if @enquiry.save
      render json: @enquiry, status: :created
    else
      render json: @enquiry.errors, status: :unprocessable_entity
    end
  end

  def update
    if @enquiry.update(enquiry_params)
      render json: @enquiry
    else
      render json: @enquiry.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @enquiry.destroy
    head :no_content
  end

  private

  def set_enquiry
    @enquiry = Enquiry.find(params[:id])
  end

  def enquiry_params
    params.require(:enquiry).permit(:name, :surname, :phonenumber, :email, :gender, :dob,
                                    :marital_status, :residential_address, :immigration_status,
                                    :entry_date, :passport_number, :reference_number,
                                    :document_upload, :service_type, :elaborate)
  end
end
