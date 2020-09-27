# frozen_string_literal: true

RSpec::Matchers.define :all_ok do
  match do |actual|
    actual.all? do |item|
      item.status == 'ok'
    end
  end
end
