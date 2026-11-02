# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Account", type: :request do
  it "responds successfully" do
    get account_path

    expect(response).to have_http_status(:ok)
  end
end
