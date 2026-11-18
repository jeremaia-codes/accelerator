# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Passwords", type: :request do
  before { sign_in_as create(:user) }

  it "shows the change-password form" do
    get edit_password_path

    expect(response).to have_http_status(:ok)
  end

  it "updates the password" do
    patch password_path, params: { password_challenge: "Secret1*3*5*", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }

    expect(response).to redirect_to(root_path)
  end

  it "rejects a wrong password challenge" do
    patch password_path, params: { password_challenge: "SecretWrong1*3", password: "Secret6*4*2*", password_confirmation: "Secret6*4*2*" }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to match(/Password challenge is invalid/)
  end
end
