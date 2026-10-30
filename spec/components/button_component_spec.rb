# frozen_string_literal: true

require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  it "renders its content as the button label" do
    render_inline(described_class.new) { "Save" }

    expect(page).to have_button("Save")
  end

  it "defaults to a plain button" do
    render_inline(described_class.new) { "Save" }

    expect(page).to have_css("button[type=button]")
  end

  it "accepts another button type" do
    render_inline(described_class.new(type: :submit)) { "Save" }

    expect(page).to have_css("button[type=submit]")
  end
end
