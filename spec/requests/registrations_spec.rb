# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations", type: :request do
  it "shows the sign-up form" do
    get sign_up_path

    expect(response).to have_http_status(:ok)
  end

  it "signs up a new user" do
    expect {
      post sign_up_path, params: { email: "new@example.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*" }
    }.to change(User, :count).by(1)

    expect(response).to redirect_to(root_path)
  end

  it "re-renders the form with errors when the password is too short" do
    post sign_up_path, params: { email: "new@example.com", password: "short", password_confirmation: "short" }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Password is too short")
  end
end
