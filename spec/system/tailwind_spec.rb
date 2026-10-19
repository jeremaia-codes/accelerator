# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tailwind CSS", type: :system do
  let(:check) { build(:smoke_check, path: smoke_path) }

  # The same saver capybara-screenshot runs automatically for failed specs.
  let(:saver) { Capybara::Screenshot.new_saver(Capybara, page) }

  # Remove what this example saves so tmp/screenshots only holds failures.
  after { FileUtils.rm_f([ saver.html_path, saver.screenshot_path ]) }

  it "links the compiled Tailwind stylesheet and applies its utility classes" do
    visit check.path

    expect(page).to have_css("link[rel=stylesheet][href*='tailwind']", visible: :all)

    heading = find("h1#tailwind-check", text: "Tailwind is working")
    expect(heading.style("font-weight", "font-size"))
      .to eq("font-weight" => "700", "font-size" => "36px")

    saver.save

    expect(saver).to be_html_saved
    expect(File.read(saver.html_path)).to include("Tailwind is working")
    expect(saver).to be_screenshot_saved
    expect(File.binread(saver.screenshot_path, 8)).to eq("\x89PNG\r\n\x1A\n".b)
  end
end
