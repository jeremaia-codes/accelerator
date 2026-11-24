# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account", type: :request do
  it "responds successfully when signed in" do
    sign_in_as create(:user)

    get account_path

    expect(response).to have_http_status(:ok)
  end

  it "is where the root path goes" do
    get root_path

    expect(response).to redirect_to(account_path)
  end

  it "redirects to sign in when signed out" do
    get account_path

    expect(response).to redirect_to(sign_in_path)
  end
end
