# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smoke test", type: :request do
  let(:check) { build(:smoke_check) }

  it "boots the app and responds from the health check" do
    get check.path

    expect(response).to have_http_status(check.expected_status)
  end
end
