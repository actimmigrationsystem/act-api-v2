require 'swagger_helper'

RSpec.describe 'Appointments API', type: :request do
  path '/api/v1/appointments' do
    get 'List all appointments' do
      description 'Retrieve all appointments belonging to the authenticated user.'
      tags 'Appointments'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response '200', 'Appointments retrieved successfully' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Appointment' }
        let(:Authorization) { 'Bearer valid-token' }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end

    post 'Create a new appointment' do
      description 'Create a new appointment associated with the authenticated user.'
      tags 'Appointments'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :appointment, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'John' },
          surname: { type: :string, example: 'Doe' },
          phonenumber: { type: :string, example: '+1234567890' },
          email: { type: :string, example: 'john.doe@example.com' },
          service_type: { type: :string, example: 'Immigration Consultation' },
          venue: { type: :string, example: 'Main Office' },
          appointment_date: { type: :string, format: :date, example: '2025-01-10' },
          appointment_type: { type: :string, example: 'Virtual' }
        },
        required: %w[name surname phonenumber email service_type venue appointment_date appointment_type]
      }

      response '201', 'Appointment created successfully' do
        schema '$ref' => '#/components/schemas/Appointment'
        let(:Authorization) { 'Bearer valid-token' }
        let(:appointment) do
          { name: 'John', surname: 'Doe', phonenumber: '+1234567890', email: 'john.doe@example.com',
            service_type: 'Immigration Consultation', venue: 'Main Office', appointment_date: '2025-01-10', appointment_type: 'Virtual' }
        end
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer valid-token' }
        let(:appointment) { { name: '', surname: '' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/appointments/{id}' do
    get 'Retrieve a specific appointment' do
      description 'Retrieve a specific appointment belonging to the authenticated user.'
      tags 'Appointments'
      security [{ bearerAuth: [] }]
      produces 'application/json'
      parameter name: :id, in: :path, schema: { type: :integer }, required: true

      response '200', 'Appointment retrieved successfully' do
        schema '$ref' => '#/components/schemas/Appointment'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Appointment.create!(valid_attributes).id }
        run_test!
      end

      response '404', 'Appointment not found' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { 0 }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end

    put 'Update an appointment' do
      description 'Update an appointment belonging to the authenticated user.'
      tags 'Appointments'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, schema: { type: :integer }, required: true
      parameter name: :appointment, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Updated John' }
        },
        required: ['name']
      }

      response '200', 'Appointment updated successfully' do
        schema '$ref' => '#/components/schemas/Appointment'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Appointment.create!(valid_attributes).id }
        let(:appointment) { { name: 'Updated John' } }
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Appointment.create!(valid_attributes).id }
        let(:appointment) { { name: '' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end

    delete 'Delete an appointment' do
      description 'Delete an appointment belonging to the authenticated user.'
      tags 'Appointments'
      security [{ bearerAuth: [] }]
      parameter name: :id, in: :path, schema: { type: :integer }, required: true

      response '200', 'Appointment deleted successfully' do
        schema type: :object, properties: { message: { type: :string, example: 'Appointment deleted successfully' } }
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Appointment.create!(valid_attributes).id }
        run_test!
      end

      response '404', 'Appointment not found' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { 0 }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
