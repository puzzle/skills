require 'swagger_helper'

RSpec.describe Api::CvsController, type: :request do
  path '/api/cvs' do
    get 'Returns all CVs' do
      tags 'CVs'
      produces 'application/json'

      parameter name: :anon,
                in: :query,
                type: :boolean,
                required: false,
                description: 'Return anonymized CV data (email and birthdate may be hidden)'

      response '200', 'CVs returned successfully' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     '$ref' => '#/components/schemas/Cv'
                   }
                 }
               }

        run_test!
      end
    end
  end
end
