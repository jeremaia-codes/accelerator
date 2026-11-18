# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  it "lists the user's sessions" do
    sign_in_as user

    get sessions_path

    expect(response).to have_http_status(:ok)
  end

  it "shows the sign-in form" do
    get sign_in_path

    expect(response).to have_http_status(:ok)
  end

  it "signs in with valid credentials" do
    post sign_in_path, params: { email: user.email, password: "Secret1*3*5*" }
    expect(response).to redirect_to(root_path)

    get root_path
    expect(response).to have_http_status(:ok)
  end

  it "rejects invalid credentials" do
    post sign_in_path, params: { email: user.email, password: "SecretWrong1*3" }
    expect(response).to redirect_to(sign_in_path(email_hint: user.email))
    expect(flash[:alert]).to eq("That email or password is incorrect")

    get root_path
    expect(response).to redirect_to(sign_in_path)
  end

  it "signs out" do
    sign_in_as user

    delete session_path(user.sessions.last)
    expect(response).to redirect_to(sessions_path)

    follow_redirect!
    expect(response).to redirect_to(sign_in_path)
  end
end
