require 'swagger_helper'

RSpec.describe 'Users', type: :request, capture_examples: true do
  path 'api/users' do
    post 'Create an User' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          profile: { type: :integer },
          registration: { type: :string },
          email: { type: :string },
          password_digest: { type: :string }
        },
        required: ['name', 'email']
      }

      response "201", "user created" do
        let(:user) { { user_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:user) { { user_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/users/{id}' do
    get 'Get User' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

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

    path 'api/users/class_group/{class_id}/associate' do
      put 'Associate User in group' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            user_id: { type: :integer },
            class_group_id: { type: :integer }
          },
          required: ['user_id', 'class_group_id']
        }
  
        response "201", "user not found" do
          let(:status) { true }
          run_test!
        end
        response "422", "invalid request" do
          let(:status) { false }
          run_test!
        end
      end
    end

    path 'api/users/reset/{user_id}' do
      patch 'Reset Password User' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            password_digest: { type: :string }
          },
          required: ['password_digest']
        }
  
        response "201", "user reseted" do
          let(:status) { true }
          run_test!
        end
        response "422", "invalid request" do
          let(:status) { false }
          run_test!
        end
      end
    end

    path 'api/users/{id}' do
      delete 'Delete User' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :id, in: :path, type: :integer
  
        response '200', 'user found' do
          schema type: :object,
            properties: {
              status: { type: :boolean }
            },
            required: [ 'status' ]
  
          let(:id) { User.find_by(id: 1).destroy }
          run_test! do |response|
            data = JSON.parse(response.body)
            expect(data['status']).to eq('true')
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
end
