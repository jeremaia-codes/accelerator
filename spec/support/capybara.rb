# frozen_string_literal: true

RSpec.configure do |config|
  # Fast, JavaScript-free driver by default for system specs.
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # Tag a spec with `js: true` to run it in headless Chrome.
  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  end
end
