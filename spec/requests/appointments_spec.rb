require 'swagger_helper'

RSpec.describe 'Appointments API', type: :request do
  path '/api/v1/appointments' do
    get('list appointments') do
      tags 'Appointments'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
