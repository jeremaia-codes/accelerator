# frozen_string_literal: true

# Signs a user in through the real sign-in form so the session cookie is set.
module AuthenticationHelpers
  PASSWORD = "Secret1*3*5*"

  module Request
    def sign_in_as(user, password: PASSWORD)
      post sign_in_path, params: { email: user.email, password: password }
      user
    end
  end

  module System
    def sign_in_as(user, password: PASSWORD)
      visit sign_in_path
      fill_in "Email", with: user.email
      fill_in "Password", with: password
      click_on "Sign in"
      expect(page).to have_text("Signed in successfully")
      user
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers::Request, type: :request
  config.include AuthenticationHelpers::System, type: :system
  config.include ActiveSupport::Testing::TimeHelpers, type: :request
end
