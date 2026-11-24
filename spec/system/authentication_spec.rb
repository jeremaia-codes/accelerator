# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Authentication", type: :system do
  it "signs up a new user" do
    visit sign_up_path

    fill_in "Email", with: "new@example.com"
    fill_in "Password", with: "Secret1*3*5*"
    fill_in "Password confirmation", with: "Secret1*3*5*"
    click_on "Sign up"

    expect(page).to have_text("Welcome! You have signed up successfully")
  end

  it "signs in an existing user" do
    user = create(:user)

    visit sign_in_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "Secret1*3*5*"
    click_on "Sign in"

    expect(page).to have_text("Signed in successfully")
    expect(page).to have_current_path(account_path)
  end

  it "shows an alert for wrong credentials" do
    visit sign_in_path
    fill_in "Email", with: "nobody@example.com"
    fill_in "Password", with: "wrong-password"
    click_on "Sign in"

    expect(page).to have_css("#sign_in_error[role=alert]", text: "That email or password is incorrect")
    expect(page).to have_css("#password[aria-invalid=true][aria-describedby=sign_in_error]")
    expect(page).to have_field("Email", with: "nobody@example.com")
  end

  it "shows sign-up errors under the fields they belong to" do
    create(:user, email: "taken@example.com")

    visit sign_up_path
    fill_in "Email", with: "taken@example.com"
    fill_in "Password", with: "short"
    fill_in "Password confirmation", with: "different"
    click_on "Sign up"

    expect(page).to have_css("#email[aria-invalid=true][aria-describedby=email_error]")
    expect(page).to have_css("#email_error", text: "Email has already been taken")
    expect(page).to have_css("#password_error", text: "Password is too short")
    expect(page).to have_css("#password_confirmation_error", text: "Password confirmation doesn't match Password")
  end

  it "links from sign in to the password reset page" do
    visit sign_in_path
    click_on "Forgot your password?"

    expect(page).to have_css("h1", text: "Forgot your password?")
  end
end
