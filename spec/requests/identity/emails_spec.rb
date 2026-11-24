# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Identity::Emails", type: :request do
  before { sign_in_as create(:user) }

  it "shows the change-email form" do
    get edit_identity_email_path

    expect(response).to have_http_status(:ok)
  end

  it "updates the email" do
    patch identity_email_path, params: { email: "new_email@example.com", password_challenge: "Secret1*3*5*" }

    expect(response).to redirect_to(edit_identity_email_path)
  end

  it "rejects a wrong password challenge" do
    patch identity_email_path, params: { email: "new_email@example.com", password_challenge: "SecretWrong1*3" }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to match(/Current password is invalid/)
  end
end
