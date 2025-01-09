require 'swagger_helper'

RSpec.describe 'Enquiries API', type: :request do
  path '/api/v1/enquiries' do
    get 'List all enquiries' do
      description 'Retrieve all enquiries belonging to the authenticated user.'
      tags 'Enquiries'
      security [{ bearerAuth: [] }]
      produces 'application/json'

      response '200', 'Enquiries retrieved successfully' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Enquiry' }
        let(:Authorization) { 'Bearer valid-token' }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end

    post 'Create a new enquiry' do
      description 'Create a new enquiry associated with the authenticated user.'
      tags 'Enquiries'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :enquiry, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'John' },
          surname: { type: :string, example: 'Doe' },
          phonenumber: { type: :string, example: '+123456789' },
          email: { type: :string, example: 'john.doe@example.com' },
          gender: { type: :string, example: 'Male' },
          dob: { type: :string, format: :date, example: '1990-01-01' },
          marital_status: { type: :string, example: 'Single' },
          residential_address: { type: :string, example: '123 Main Street' },
          entry_date: { type: :string, format: :date, example: '2022-01-01' },
          passport_number: { type: :string, example: 'A12345678' },
          reference_number: { type: :string, example: 'REF001' },
          service_type: { type: :string, example: 'Immigration Consultation' },
          elaborate: { type: :string, example: 'Details of the enquiry' },
          immigration_status: { type: :string, example: 'Pending' }
        },
        required: %w[name surname phonenumber email service_type]
      }

      response '201', 'Enquiry created successfully' do
        schema '$ref' => '#/components/schemas/Enquiry'
        let(:Authorization) { 'Bearer valid-token' }
        let(:enquiry) do
          { name: 'John', surname: 'Doe', phonenumber: '+123456789', email: 'john.doe@example.com',
            service_type: 'Immigration Consultation' }
        end
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer valid-token' }
        let(:enquiry) { { name: '', surname: '' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end
  end

  path '/api/v1/enquiries/{id}' do
    get 'Retrieve a specific enquiry' do
      description 'Retrieve a specific enquiry belonging to the authenticated user.'
      tags 'Enquiries'
      security [{ bearerAuth: [] }]
      produces 'application/json'
      parameter name: :id, in: :path, schema: { type: :integer }, required: true

      response '200', 'Enquiry retrieved successfully' do
        schema '$ref' => '#/components/schemas/Enquiry'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Enquiry.create!(valid_attributes).id }
        run_test!
      end

      response '404', 'Enquiry not found' do
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

    put 'Update an enquiry' do
      description 'Update an enquiry belonging to the authenticated user.'
      tags 'Enquiries'
      security [{ bearerAuth: [] }]
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, schema: { type: :integer }, required: true
      parameter name: :enquiry, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'John Updated' }
        },
        required: ['name']
      }

      response '200', 'Enquiry updated successfully' do
        schema '$ref' => '#/components/schemas/Enquiry'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Enquiry.create!(valid_attributes).id }
        let(:enquiry) { { name: 'John Updated' } }
        run_test!
      end

      response '422', 'Unprocessable entity' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Enquiry.create!(valid_attributes).id }
        let(:enquiry) { { name: '' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema '$ref' => '#/components/schemas/Error'
        let(:Authorization) { nil }
        run_test!
      end
    end

    delete 'Delete an enquiry' do
      description 'Delete an enquiry belonging to the authenticated user.'
      tags 'Enquiries'
      security [{ bearerAuth: [] }]
      parameter name: :id, in: :path, schema: { type: :integer }, required: true

      response '200', 'Enquiry deleted successfully' do
        schema type: :object, properties: { message: { type: :string, example: 'Enquiry deleted successfully' } }
        let(:Authorization) { 'Bearer valid-token' }
        let(:id) { Enquiry.create!(valid_attributes).id }
        run_test!
      end

      response '404', 'Enquiry not found' do
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
