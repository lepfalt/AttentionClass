require 'swagger_helper'

RSpec.describe 'Sessions', type: :request do
  path 'api/sessions' do
    post 'Authentication User' do
      tags 'Sessions'
      consumes 'application/json'
      parameter name: :email, in: :path, type: :string
      parameter name: :password_digest, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            profile: { type: :integer },
            email: { type: :string },
            registration: { type: :string }
          },
          required: [ 'id', 'name', 'email', 'profile' ]

        let(:id) { User.create(name: 'Teste', email: 'teste@gmail.com').id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq('Teste')
        end
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end
end
