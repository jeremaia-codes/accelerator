# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account", type: :request do
  it "renders the account frame with the sidenav item marked current" do
    get account_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("<title>Account</title>")
    expect(response.body).to match(%r{<h1[^>]*>Account</h1>})
    expect(response.body).to match(/<a[^>]*aria-current="page"[^>]*href="#{account_path}"/)
  end
end
