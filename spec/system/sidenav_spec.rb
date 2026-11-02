# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sidenav", type: :system do
  let(:hamburger) { "button[aria-label='Open menu']" }

  # Capybara reuses one browser window for every example, so put its size back.
  after { page.current_window.resize_to(*@original_size) if @original_size }

  def resize_window(width, height)
    @original_size ||= page.current_window.size
    page.current_window.resize_to(width, height)
  end

  context "below the md breakpoint" do
    before do
      resize_window(600, 800)
      visit account_path
    end

    it "hides the menu until the hamburger opens it" do
      expect(page).to have_no_css("aside")

      find(hamburger).click

      expect(page).to have_css("aside", text: "Account")
      expect(page).to have_css("button[aria-expanded='true']", visible: :all)
    end

    it "closes the menu with the escape key" do
      find(hamburger).click
      find("body").send_keys(:escape)

      expect(page).to have_no_css("aside")
      expect(page).to have_css("button[aria-expanded='false']")
    end

    it "closes the menu when the page behind it is clicked" do
      find(hamburger).click
      find("[data-sidenav-target='backdrop']").click(x: 200, y: 0)

      expect(page).to have_no_css("aside")
    end
  end

  context "from the md breakpoint up" do
    it "shows the menu without the hamburger" do
      resize_window(1280, 800)
      visit account_path

      expect(page).to have_css("aside", text: "Account")
      expect(page).to have_no_css(hamburger)
    end
  end

  # These run in order: the second proves the first gave the window back.
  context "when one example resizes the window", order: :defined do
    it "shrinks the window" do
      resize_window(500, 800)

      expect(page.current_window.size).to eq([ 500, 800 ])
    end

    it "leaves the next example with the original size" do
      expect(page.current_window.size.first).not_to eq(500)
    end
  end
end
