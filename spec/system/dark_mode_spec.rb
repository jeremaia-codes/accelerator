# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dark mode", type: :system do
  let(:toggle) { "button[aria-label='Dark mode']" }

  def dark_mode?
    page.evaluate_script("document.documentElement.classList.contains('dark')")
  end

  # Starts from light mode, whatever the test browser's system setting is.
  # Called inside each example, as rspec-rails only picks the JS driver after
  # this group's own before hooks have run.
  def visit_in_light_mode
    sign_in_as create(:user)
    visit account_path
    page.execute_script("localStorage.setItem('darkMode', 'false')")
    visit account_path
  end

  # Capybara reuses one browser for every example, so forget the choice.
  after { page.execute_script("localStorage.clear()") }

  it "shows one toggle" do
    sign_in_as create(:user)

    expect(page).to have_css(toggle, count: 1)
  end

  it "switches between light and dark mode" do
    visit_in_light_mode

    expect(page).to have_css("#{toggle}[aria-pressed='false']")
    expect(dark_mode?).to be(false)

    find(toggle).click

    expect(page).to have_css("#{toggle}[aria-pressed='true']")
    expect(dark_mode?).to be(true)

    find(toggle).click

    expect(page).to have_css("#{toggle}[aria-pressed='false']")
    expect(dark_mode?).to be(false)
  end

  it "remembers the choice on the next page load" do
    visit_in_light_mode

    find(toggle).click
    visit account_path

    expect(page).to have_css("#{toggle}[aria-pressed='true']")
    expect(dark_mode?).to be(true)
  end

  it "uses the dark colour tokens in dark mode" do
    visit_in_light_mode

    background = -> { page.evaluate_script("getComputedStyle(document.body).backgroundColor") }

    expect(background.call).to eq("rgb(247, 247, 245)")

    find(toggle).click

    expect(background.call).to eq("rgb(10, 10, 10)")
  end
end
