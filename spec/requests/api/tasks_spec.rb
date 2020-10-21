require 'swagger_helper'

RSpec.describe 'Tasks', type: :request do
  path 'api/tasks' do
    post 'Create a Task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          class_group_id: { type: :integer },
          description: { type: :string },
          status: { type: :integer },
          expiration_date: { type: :date }
        },
        required: ['title', 'class_group_id', 'description', 'status', 'expiration_date']
      }

      response "201", "task created" do
        let(:task) { { task_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:task) { { task_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/tasks/{id}' do
    get 'Get Task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
          properties: {
            title: { type: :string },
            class_group_id: { type: :integer },
            description: { type: :string },
            status: { type: :integer },
            expiration_date: { type: :date },
            active: { type: :boolean }
          },
          required: ['id', 'title', 'class_group_id', 'description', 'status', 'expiration_date', 'active']

        # let(:id) { User.create(name: 'Teste', email: 'teste@gmail.com').id }
        # run_test! do |response|
        #   data = JSON.parse(response.body)
        #   expect(data['name']).to eq('Teste')
        # end
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path 'api/tasks/{id}' do
    put 'Update a Task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :integer },
          expiration_date: { type: :date }
        },
        required: ['title', 'description', 'status', 'expiration_date']
      }

      response "201", "task updated" do
        let(:task) { { task_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:task) { { task_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/tasks/user/{user_id}' do
    get 'Get Tasks by Responsible of Group' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
          properties: [{
            title: { type: :string },
            class_group_id: { type: :integer },
            description: { type: :string },
            status: { type: :integer },
            expiration_date: { type: :date },
            active: { type: :boolean }
          }],
          required: ['id', 'title', 'class_group_id', 'description', 'status', 'expiration_date', 'active']
      end

      response '404', 'tasks not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path 'api/tasks/{id}' do
    delete 'Delete Task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'task found' do
        schema type: :object,
          properties: {
            status: { type: :boolean }
          },
          required: [ 'status' ]

        let(:id) { Task.find_by(id: 1).destroy }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['status']).to eq('true')
        end
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end

    patch 'Cancel a Task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          active: { type: :boolean }
        },
        required: ['active']
      }

      response "201", "task canceled" do
        let(:task) { { task_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:task) { { task_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/task/{id}/responses' do
    get 'Get Responses by Task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        schema type: :object,
          properties: [{
            user_id: { type: :integer },
            response_value: { type: :string },
            response_annotation: { type: :string },
            status: { type: :integer },
            grade: { type: :float },
            observation_responsible: { type: :string }
          }],
          required: ['user_id', 'response_value', 'response_annotation', 'status', 'status', 'grade', 'observation_responsible']
      end

      response '404', 'responses not found' do
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
