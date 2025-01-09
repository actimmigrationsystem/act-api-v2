require 'swagger_helper'

RSpec.describe 'Enquiries API', type: :request do
  path '/api/v1/enquiries' do
    get('list enquiries') do
      tags 'Enquiries'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end
end
