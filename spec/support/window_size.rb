# frozen_string_literal: true

# Resizes the browser window for one example. Capybara reuses one browser
# window for every example, so the original size is put back afterwards.
module WindowSizeHelpers
  def resize_window(width, height)
    @original_size ||= page.current_window.size
    page.current_window.resize_to(width, height)
  end
end

RSpec.configure do |config|
  config.include WindowSizeHelpers, type: :system
  config.after(type: :system) { page.current_window.resize_to(*@original_size) if @original_size }
end
