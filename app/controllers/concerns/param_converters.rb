# frozen_string_literal: true

module ParamConverters

  private

  def true?(value)
    %w[1 yes true].include?(value.to_s.downcase)
  end

  def false?(value)
    %w[0 no false].include?(value.to_s.downcase)
  end

  def nil_param?(value)
    value == 'null' ? nil : value
  end
end