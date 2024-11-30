module Api
  module V1
    class AppointmentsController < ApplicationController
      before_action :set_appointment, only: [:show, :update, :destroy]

      def index
        appointments = Appointment.all
        render json: appointments, status: :ok
      end

      def show
        render json: @appointment, status: :ok
      end

      def create
        appointment = Appointment.new(appointment_params)
        if appointment.save
          render json: appointment, status: :created
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @appointment.update(appointment_params)
          render json: @appointment, status: :ok
        else
          render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @appointment.destroy
        render json: { message: 'Appointment deleted successfully' }, status: :ok
      end

      private

      def set_appointment
        @appointment = Appointment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Appointment not found' }, status: :not_found
      end

      def appointment_params
        params.require(:appointment).permit(:name, :surname, :phonenumber, :email, :service_type, :venue, :appointment_date, :appointment_type)
      end
    end
  end
end
