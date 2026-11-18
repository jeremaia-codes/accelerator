# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Identity::EmailVerifications", type: :request do
  let(:user) { create(:user, :unverified) }

  before { sign_in_as user }

  it "sends a verification email" do
    expect {
      post identity_email_verification_path
    }.to have_enqueued_mail(UserMailer, :email_verification).with(params: { user: user }, args: [])

    expect(response).to redirect_to(root_path)
  end

  it "verifies the email" do
    sid = user.generate_token_for(:email_verification)

    get identity_email_verification_path(sid: sid, email: user.email)

    expect(response).to redirect_to(root_path)
    expect(user.reload).to be_verified
  end

  it "rejects an expired token" do
    sid = user.generate_token_for(:email_verification)

    travel 3.days
    get identity_email_verification_path(sid: sid, email: user.email)

    expect(response).to redirect_to(edit_identity_email_path)
    expect(flash[:alert]).to eq("That email verification link is invalid")
  end
end
