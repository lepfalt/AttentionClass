# frozen_string_literal: true

module FixturesJsonHelper
  def get_json(name)
    File.read((Rails.root.join 'spec', 'fixtures', "#{name}.json"))
  end
end
