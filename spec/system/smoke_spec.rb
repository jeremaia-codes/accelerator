# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smoke test", type: :system do
  let(:check) { build(:smoke_check) }

  it "renders the health check page in a browser with JavaScript" do
    visit check.path

    background = page.evaluate_script("getComputedStyle(document.body).backgroundColor")
    expect(background).to eq("rgb(0, 128, 0)")
  end

  describe "screenshots" do
    # The same saver capybara-screenshot runs automatically for failed specs.
    let(:saver) { Capybara::Screenshot.new_saver(Capybara, page) }

    # Remove what this example saves so tmp/screenshots only holds failures.
    after { FileUtils.rm_f([ saver.html_path, saver.screenshot_path ]) }

    it "saves an HTML snapshot and a PNG screenshot of the page" do
      visit check.path

      saver.save

      expect(saver).to be_html_saved
      expect(File.read(saver.html_path)).to include("background-color: green")
      expect(saver).to be_screenshot_saved
      expect(File.binread(saver.screenshot_path, 8)).to eq("\x89PNG\r\n\x1A\n".b)
    end
  end
end
