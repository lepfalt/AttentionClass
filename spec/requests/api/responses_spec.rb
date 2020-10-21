require 'swagger_helper'

RSpec.describe 'Responses', type: :request do
  path 'api/responses' do
    post 'Create a Response' do
      tags 'Responses'
      consumes 'application/json'
      parameter name: :response, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          task_id: { type: :integer },
          status: { type: :integer }
        },
        required: ['user_id', 'task_id', 'status']
      }

      response "201", "response created" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/responses/{id}' do
    get 'Get Response' do
      tags 'Responses'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            user_id: { type: :integer },
            task_id: { type: :integer },
            response_value: { type: :string },
            response_annotation: { type: :string },
            status: { type: :integer },
            grade: { type: :float },
            observation_responsible: { type: :string },
            active: { type: :boolean }
          },
          required: ['id', 'user_id', 'task_id', 'response_value', 'response_annotation', 'status', 'status', 'grade', 'observation_responsible', 'active']
      end

      response '404', 'response not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path 'api/responses/{id}' do
    put 'Update a Response' do
      tags 'Responses'
      consumes 'application/json'
      parameter name: :response, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          response_value: { type: :string },
          response_annotation: { type: :string },
          status: { type: :integer }
        },
        required: ['id', 'response_value', 'response_annotation', 'status']
      }

      response "201", "response updated" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
    end

    patch 'Evaluate a Response' do
      tags 'Responses'
      consumes 'application/json'
      parameter name: :response, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          grade: { type: :float },
          observation_responsible: { type: :string }
        },
        required: ['id', 'grade', 'observation_responsible']
      }

      response "201", "response evaluated" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/responses/{id}/desactive' do
    patch 'Delete a Response' do
      tags 'Responses'
      consumes 'application/json'
      parameter name: :response, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :integer },
          active: { type: :boolean }
        },
        required: ['id', 'active']
      }

      response "201", "response deleted" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:response) { { response_id: 10 } }
        run_test!
      end
    end
  end
end
