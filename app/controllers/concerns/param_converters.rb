# frozen_string_literal: true

module ParamConverters
  private

  TRUTHY_VALUES = %w(t true yes y 1).freeze
  FALSEY_VALUES = %w(f false n no 0).freeze


  def true?(value)
    TRUTHY_VALUES.include?(value.to_s.downcase)
  end

  def false?(value)
    FALSEY_VALUES.include?(value.to_s.downcase)
  end

  def to_boolean(value)
    return true if true?(value)
    return false if false?(value)

    raise "Invalid value '#{value}' for boolean casting"
  end
end
