# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  it "builds the password reset email" do
    mail = described_class.with(user: user).password_reset

    expect(mail.subject).to eq("Reset your password")
    expect(mail.to).to eq([ user.email ])
  end

  it "builds the email verification email" do
    mail = described_class.with(user: user).email_verification

    expect(mail.subject).to eq("Verify your email")
    expect(mail.to).to eq([ user.email ])
  end
end
