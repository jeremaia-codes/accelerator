# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smoke test", type: :system do
  let(:check) { build(:smoke_check) }

  it "renders the health check page" do
    visit check.path

    expect(page.status_code).to eq(check.expected_status)
    expect(page).to have_css("body[style*='green']")
  end

  it "renders the health check page in a real browser", js: true do
    visit check.path

    background = page.evaluate_script("getComputedStyle(document.body).backgroundColor")
    expect(background).to eq("rgb(0, 128, 0)")
  end

  describe "screenshots" do
    # The same saver capybara-screenshot runs automatically for failed specs.
    let(:saver) { Capybara::Screenshot.new_saver(Capybara, page) }

    # Remove what these examples save so tmp/screenshots only holds failures.
    after { FileUtils.rm_f([ saver.html_path, saver.screenshot_path ]) }

    it "saves an HTML snapshot of the page" do
      visit check.path

      saver.save

      expect(saver).to be_html_saved
      expect(File.read(saver.html_path)).to include("background-color: green")
      # rack_test can't render images.
      expect(saver).not_to be_screenshot_saved
    end

    it "saves an HTML snapshot and a PNG screenshot in a real browser", js: true do
      visit check.path

      saver.save

      expect(saver).to be_html_saved
      expect(saver).to be_screenshot_saved
      expect(File.binread(saver.screenshot_path, 8)).to eq("\x89PNG\r\n\x1A\n".b)
    end
  end
end
