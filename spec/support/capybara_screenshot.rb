# frozen_string_literal: true

require "capybara-screenshot/rspec"

# Save the HTML (and, for browser specs, a PNG) of every failed system spec.
# CI uploads tmp/screenshots when the system-test job fails.
Capybara.save_path = Rails.root.join("tmp/screenshots")
