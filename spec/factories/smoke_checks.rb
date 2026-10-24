# frozen_string_literal: true

FactoryBot.define do
  factory :smoke_check do
    # Not an Active Record model: "creating" one just validates it, so
    # FactoryBot.lint still catches invalid attributes.
    to_create(&:validate!)

    path { "/up" }
    expected_status { 200 }
  end
end
