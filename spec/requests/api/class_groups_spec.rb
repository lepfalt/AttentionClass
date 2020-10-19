require 'swagger_helper'

RSpec.describe 'Groups', type: :request do
  path 'api/class_groups' do
    post 'Create an Group' do
      tags 'Groups'
      consumes 'application/json'
      parameter name: :class_group, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          discipline: { type: :string },
          class_code: { type: :string },
          expiration_date: { type: :date }
        },
        required: ['user_id', 'discipline', 'class_code', 'expiration_date']
      }

      response "201", "group created" do
        let(:group) { { group_id: 10 } }
        run_test!
      end
      response "422", "invalid request" do
        let(:group) { { group_id: 10 } }
        run_test!
      end
    end
  end

  path 'api/class_groups/{id}' do
    get 'Get Group' do
      tags 'Groups'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'group found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            user_id: { type: :integer },
            discipline: { type: :string },
            class_code: { type: :string },
            expiration_date: { type: :date },
            active: { type: :boolean }
          },
          required: ['id', 'user_id', 'discipline', 'class_code', 'expiration_date', 'active']

        # let(:id) { ClassGroup.create(name: 'Teste', email: 'teste@gmail.com').id }
        # run_test! do |response|
        #   data = JSON.parse(response.body)
        #   expect(data['name']).to eq('Teste')
        # end
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

  path 'api/class_groups/{id}/users' do
    get 'Get Users of Group' do
      tags 'Groups'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'group found' do
        schema type: :object,
          properties: [{
            id: { type: :integer },
            name: { type: :string },
            profile: { type: :integer },
            email: { type: :string },
            registration: { type: :string }
          }],
          required: [ 'id', 'name', 'email', 'profile' ]

        # let(:id) { ClassGroup.create(name: 'Teste', email: 'teste@gmail.com').id }
        # run_test! do |response|
        #   data = JSON.parse(response.body)
        #   expect(data['name']).to eq('Teste')
        # end
      end

      response '404', 'users not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path 'api/class_groups' do
    get 'Get Groups by Responsible' do
      tags 'Groups'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :integer, require: false

      response '200', 'group found' do
        schema type: :object,
          properties: [{
            id: { type: :integer },
            user_id: { type: :integer },
            discipline: { type: :string },
            class_code: { type: :string },
            expiration_date: { type: :date },
            active: { type: :boolean }
          }],
          required: ['id', 'user_id', 'discipline', 'class_code', 'expiration_date', 'active']

        # let(:id) { ClassGroup.create(name: 'Teste', email: 'teste@gmail.com').id }
        # run_test! do |response|
        #   data = JSON.parse(response.body)
        #   expect(data['name']).to eq('Teste')
        # end
      end

      response '404', 'groups not found' do
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end

  path 'api/class_groups/{id}' do
    delete 'Delete Group' do
      tags 'Groups'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'group deleted' do
        schema type: :object,
          properties: {
            status: { type: :boolean }
          },
          required: [ 'status' ]

        # let(:id) { User.find_by(id: 1).destroy }
        # run_test! do |response|
        #   data = JSON.parse(response.body)
        #   expect(data['status']).to eq('true')
        # end
      end

      response '404', 'group not found' do
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
