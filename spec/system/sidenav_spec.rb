# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sidenav", type: :system do
  let(:hamburger) { "button[aria-label='Open menu']" }

  context "below the md breakpoint" do
    before do
      visit account_path
      page.current_window.resize_to(600, 800)
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
      visit account_path
      page.current_window.resize_to(1280, 800)

      expect(page).to have_css("aside", text: "Account")
      expect(page).to have_no_css(hamburger)
    end
  end
end
