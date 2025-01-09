# frozen_string_literal: true

require 'rails_helper'
require 'rswag/specs'
require 'rswag/api'
require 'rswag/ui'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Act Immigration API V2',
        description: 'This API provides endpoints for managing appointments and related resources. Each endpoint is secured and role-based access applies.',
        termsOfService: 'https://act-api-v2.onrender.com/terms',
        contact: {
          name: 'Support Team',
          email: 'support@act-immigration.com',
          url: 'https://act-api-v2.onrender.com/contact'
        },
        license: {
          name: 'MIT License',
          url: 'https://opensource.org/licenses/MIT'
        },
        version: 'v1'
      },
      servers: [
        {
          url: 'https://act-api-v2.onrender.com',
          description: 'Production server'
        },
        {
          url: 'http://localhost:3000',
          description: 'Local development server'
        }
      ],
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        },
        schemas: {
          Appointment: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'John' },
              surname: { type: :string, example: 'Doe' },
              phonenumber: { type: :string, example: '+1234567890' },
              email: { type: :string, example: 'john.doe@example.com' },
              service_type: { type: :string, example: 'Immigration Consultation' },
              venue: { type: :string, example: 'Main Office' },
              appointment_date: { type: :string, format: :date, example: '2025-01-10' },
              appointment_type: { type: :string, example: 'Virtual' },
              created_at: { type: :string, format: :date - time },
              updated_at: { type: :string, format: :date - time }
            }
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string, example: 'Unauthorized access' }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
  # config.swagger_format = :yaml
end
