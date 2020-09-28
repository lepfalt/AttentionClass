require 'rails_helper'
require 'support/fixtures_json_helper'
require 'support/constants_helper'

RSpec.describe User, type: :model do
  include FixturesJsonHelper
  include ConstantsHelper

  let(:user_params) do
    {
      id: 1,
      profile: :admin,
      name: 'Letícia',
      registration: '2017200024537',
      email: 'lepfalt@gmail.com',
      password: ''
    }
  end

  subject do
    described_class.create(user_params)
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:profile) }
    it { should validate_presence_of(:password) }

    it do
      described_class.create(user_params)

      acceptable_values = [
        ConstantsHelper::STANDARD,
        ConstantsHelper::ADMIN
      ]
      ## TODO ajustar enum
      # should validate_inclusion_of(subject.profile).in_array(acceptable_values)
    end
  end

  describe 'set default values' do
    let(:user) { described_class.create(user_params) }

    it { expect(user.id).to_not be_nil } #Ver pra gerar id diferente depois
    it { expect(user.profile).to eq('admin') }
  end
end
