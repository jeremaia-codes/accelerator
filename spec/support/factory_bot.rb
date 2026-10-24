# frozen_string_literal: true

RSpec.configure do |config|
  # Call build/create/attributes_for without the FactoryBot prefix.
  config.include FactoryBot::Syntax::Methods
end
