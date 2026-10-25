# frozen_string_literal: true

# System specs run in headless Chrome (rspec-rails' default). Set
# TEST_BROWSER=true to watch them run in a visible Chrome window instead:
#
#   TEST_BROWSER=true bin/rspec spec/system
RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome if ActiveModel::Type::Boolean.new.cast(ENV["TEST_BROWSER"])
  end
end
