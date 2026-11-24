# frozen_string_literal: true

module ApplicationHelper
  # The error message shown under a form field, or nothing when the field is valid.
  def field_error(record, attribute)
    return unless record&.errors&.include?(attribute)

    tag.p record.errors.full_messages_for(attribute).to_sentence, id: field_error_id(attribute), class: "form-error"
  end

  # ARIA attributes that mark a field as invalid and link it to its error message.
  def field_error_aria(record, attribute)
    return {} unless record&.errors&.include?(attribute)

    { invalid: true, describedby: field_error_id(attribute) }
  end

  private
    def field_error_id(attribute)
      "#{attribute}_error"
    end
end
