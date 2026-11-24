# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User menu", type: :system do
  let(:user_button) { "aside button[aria-controls='user_menu']" }

  # Called inside each example, as rspec-rails only picks the JS driver after
  # this group's own before hooks have run.
  def sign_in
    sign_in_as create(:user, email: "ada@example.com")
    resize_window(1280, 800)
  end

  it "shows the user's name at the bottom of the sidenav" do
    sign_in
    expect(page).to have_css(user_button, text: "ada")
  end

  it "opens with the account settings link above sign out" do
    sign_in
    expect(page).to have_no_css("#user_menu")

    find(user_button).click

    expect(page).to have_css("#{user_button}[aria-expanded='true']")
    expect(page.all("#user_menu a, #user_menu button").map(&:text)).to eq([ "Account settings", "Sign out" ])
  end

  it "closes when the page behind it is clicked" do
    sign_in
    find(user_button).click
    find("main").click

    expect(page).to have_no_css("#user_menu")
  end

  it "closes with the escape key" do
    sign_in
    find(user_button).click
    find(user_button).send_keys(:escape)

    expect(page).to have_no_css("#user_menu")
    expect(page).to have_css("#{user_button}:focus")
  end

  it "goes to the account settings page, which has its own sidenav" do
    sign_in
    find(user_button).click
    click_on "Account settings"

    expect(page).to have_current_path(account_settings_path)
    expect(page).to have_css("h1", text: "Account settings")
    expect(page).to have_css("aside nav a[aria-current='page']", text: "Account settings")
    expect(page).to have_no_css("aside nav a", text: /\AAccount\z/)
  end

  it "signs out and goes back to the sign in page" do
    sign_in
    find(user_button).click
    click_on "Sign out"

    expect(page).to have_current_path(sign_in_path)
    expect(page).to have_text("You have signed out")

    visit account_path
    expect(page).to have_current_path(sign_in_path)
  end
end
