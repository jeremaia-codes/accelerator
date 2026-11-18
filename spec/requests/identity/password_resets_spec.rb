# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Identity::PasswordResets", type: :request do
  let(:user) { create(:user) }
  let(:new_password) { { password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" } }

  it "shows the forgot-password form" do
    get new_identity_password_reset_path

    expect(response).to have_http_status(:ok)
  end

  it "shows the reset form for a valid token" do
    get edit_identity_password_reset_path(sid: user.generate_token_for(:password_reset))

    expect(response).to have_http_status(:ok)
  end

  it "sends a password reset email" do
    expect {
      post identity_password_reset_path, params: { email: user.email }
    }.to have_enqueued_mail(UserMailer, :password_reset).with(params: { user: user }, args: [])

    expect(response).to redirect_to(sign_in_path)
  end

  it "does not email an unknown address" do
    expect {
      post identity_password_reset_path, params: { email: "unknown@example.com" }
    }.not_to have_enqueued_mail

    expect(response).to redirect_to(new_identity_password_reset_path)
    expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
  end

  it "does not email an unverified address" do
    user.update!(verified: false)

    expect {
      post identity_password_reset_path, params: { email: user.email }
    }.not_to have_enqueued_mail

    expect(response).to redirect_to(new_identity_password_reset_path)
    expect(flash[:alert]).to eq("You can't reset your password until you verify your email")
  end

  it "updates the password" do
    sid = user.generate_token_for(:password_reset)

    patch identity_password_reset_path, params: { sid: sid, **new_password }

    expect(response).to redirect_to(sign_in_path)
  end

  it "rejects an expired token" do
    sid = user.generate_token_for(:password_reset)

    travel 30.minutes
    patch identity_password_reset_path, params: { sid: sid, **new_password }

    expect(response).to redirect_to(new_identity_password_reset_path)
    expect(flash[:alert]).to eq("That password reset link is invalid")
  end
end
