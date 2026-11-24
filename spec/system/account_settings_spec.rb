# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account settings", type: :system do
  # Called inside each example, as rspec-rails only picks the JS driver after
  # this group's own before hooks have run.
  def visit_account_settings
    sign_in_as create(:user)
    resize_window(1280, 800)
    visit account_settings_path
  end

  it "links to each settings page from the sidenav" do
    visit_account_settings

    {
      "Email" => [ edit_identity_email_path, "Email" ],
      "Password" => [ edit_password_path, "Password" ],
      "Devices & sessions" => [ sessions_path, "Devices & sessions" ],
      "Account settings" => [ account_settings_path, "Account settings" ]
    }.each do |link, (path, heading)|
      within("aside nav") { click_on link }

      expect(page).to have_current_path(path)
      expect(page).to have_css("h1", text: heading)
      expect(page).to have_css("aside nav a[aria-current='page']", text: link)
    end
  end

  it "goes back to the account page" do
    visit_account_settings
    click_on "Back to Account"

    expect(page).to have_current_path(account_path)
  end

  it "keeps the link highlighted when a form shows an error" do
    visit_account_settings
    within("aside nav") { click_on "Password" }

    fill_in "Current password", with: "wrong-password"
    fill_in "New password", with: "Secret6*4*2*"
    fill_in "Confirm new password", with: "Secret6*4*2*"
    click_on "Save changes"

    expect(page).to have_css("#password_challenge_error", text: "Current password is invalid")
    expect(page).to have_css("aside nav a[aria-current='page']", text: "Password")
  end

  it "marks this device in the sessions list" do
    visit_account_settings
    within("aside nav") { click_on "Devices & sessions" }

    expect(page).to have_css("#sessions li", text: "This device", count: 1)
  end
end
