# frozen_string_literal: true

# Smoke test page proving Tailwind CSS is wired up.
class SmokeController < ApplicationController
  skip_before_action :authenticate

  def show
  end
end
