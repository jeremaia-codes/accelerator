# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smoke test", type: :system do
  let(:check) { build(:smoke_check) }

  it "renders the health check page" do
    visit check.path

    expect(page.status_code).to eq(check.expected_status)
    expect(page).to have_css("body[style*='green']")
  end

  it "renders the health check page in a real browser", js: true do
    visit check.path

    background = page.evaluate_script("getComputedStyle(document.body).backgroundColor")
    expect(background).to eq("rgb(0, 128, 0)")
  end
end
