# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  def default
    render ButtonComponent.new.with_content("Button")
  end

  def submit
    render ButtonComponent.new(type: :submit).with_content("Submit")
  end
end
