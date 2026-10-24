# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smoke test", type: :system do
  let(:check) { build(:smoke_check) }

  it "renders the health check page in a browser with JavaScript" do
    visit check.path

    background = page.evaluate_script("getComputedStyle(document.body).backgroundColor")
    expect(background).to eq("rgb(0, 128, 0)")
  end
end
