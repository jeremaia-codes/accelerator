# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(type: :button)
    @type = type
  end
end
