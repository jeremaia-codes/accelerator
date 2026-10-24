# frozen_string_literal: true

# Test-only model describing an endpoint the smoke specs expect to be up.
# It backs the example :smoke_check factory until the app has real models.
class SmokeCheck
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :path, :string
  attribute :expected_status, :integer

  validates :path, :expected_status, presence: true
end
