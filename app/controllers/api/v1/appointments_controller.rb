module Api
  module V1
    class AppointmentsController < ApplicationController
      before_action :authenticate_user! # Authenticate all actions
      before_action :set_appointment, only: %i[show update destroy]

      # GET /api/v1/appointments
      def index
        # Only return appointments belonging to the current user
        appointments = current_user.appointments
        render json: appointments, status: :ok
      end

      # GET /api/v1/appointments/:id
      def show
        # Ensure we are fetching only the current user's appointment
        render json: @appointment, status: :ok
      end

      # POST /api/v1/appointments
      def create
        # Associate the appointment with the current user
        appointment = current_user.appointments.build(appointment_params)
        if appointment.save
          render json: appointment, status: :created
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show_by_user
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
            # Superadmin can fetch all appointments of any user
            appointments = user&.appointments
            render json: appointments || { error: 'User not found' }, status: :ok
          elsif @current_user.role == 'admin'
            # Admin can view a limited subset of appointments
            appointments = user&.appointments&.limit(10)
            render json: appointments || { error: 'User not found' }, status: :ok
          elsif @current_user.role == 'client' && user == @current_user
            # Clients can fetch their own appointments
            appointments = @current_user.appointments
            render json: appointments, status: :ok
          else
            render json: { error: 'Unauthorized access' }, status: :forbidden
          end
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      # PUT /api/v1/appointments/:id
      # PATCH /api/v1/appointments/:id
      def update
        # Ensure only the owner can update their appointment
        if @appointment.update(appointment_params)
          render json: @appointment, status: :ok
        else
          render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/appointments/:id
      def destroy
        # Ensure only the owner can delete their appointment
        @appointment.destroy
        render json: { message: 'Appointment deleted successfully' }, status: :ok
      end

      private

      # Ensure we fetch the appointment belonging to the current user
      def set_appointment
        @appointment = current_user.appointments.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Appointment not found' }, status: :not_found
      end

      # Strong parameters to permit only allowed attributes
      def appointment_params
        params.require(:appointment).permit(
          :name, :surname, :phonenumber, :email,
          :service_type, :venue, :appointment_date, :appointment_type
        )
      end
    end
  end
end
