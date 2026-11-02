# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sidenav", type: :system do
  let(:hamburger) { "button[aria-label='Open menu']" }
  let(:close_button) { "button[aria-label='Close menu']" }

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

    it "moves focus into the menu and blocks the page behind it" do
      find(hamburger).click

      expect(page).to have_css("#{close_button}:focus")
      expect(page).to have_css("main[inert]")
      expect(page).to have_css("[data-sidenav-target='background'][inert]", visible: :all, count: 2)
    end

    it "gives focus back to the hamburger and unblocks the page on close" do
      find(hamburger).click
      find("aside nav a").send_keys(:escape)

      expect(page).to have_css("#{hamburger}:focus")
      expect(page).to have_no_css("[inert]", visible: :all)
    end

    it "stops the page behind from scrolling until the menu closes" do
      page.execute_script("document.querySelector('main').insertAdjacentHTML('beforeend', '<div style=\"height: 3000px\"></div>')")
      find(hamburger).click
      page.driver.browser.action.scroll_by(0, 300).perform
      sleep 0.2

      expect(page.evaluate_script("window.scrollY")).to eq(0)

      find(close_button).click
      page.driver.browser.action.scroll_by(0, 300).perform

      sleep 0.2

      expect(page.evaluate_script("window.scrollY")).to be > 0
    end

    it "closes the menu with its close button" do
      find(hamburger).click
      find(close_button).click

      expect(page).to have_no_css("aside")
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
      expect(page).to have_no_css(close_button)
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
