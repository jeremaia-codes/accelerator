# frozen_string_literal: true

require "capybara-screenshot/rspec"

# Save the HTML and a PNG of every failed system spec.
# CI uploads tmp/screenshots when the system-test job fails.
Capybara.save_path = Rails.root.join("tmp/screenshots")

# Saved HTML pages get <base href="http://localhost:3000">, so their CSS and
# JavaScript load from the dev server. Run bin/dev before opening one.
Capybara.asset_host = "http://localhost:3000"
