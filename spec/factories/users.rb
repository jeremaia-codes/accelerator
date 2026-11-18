# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { AuthenticationHelpers::PASSWORD }
    verified { true }

    trait :unverified do
      verified { false }
    end
  end
end
