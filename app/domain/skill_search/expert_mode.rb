# frozen_string_literal: true

module SkillSearch
  class ExpertMode
    LIMIT = 5

    def initialize(active)
      @active = active == '1'
    end

    def active? = @active

    def toggle_value = @active ? '0' : '1'

    def limit_reached?(filter_count) = filter_count >= LIMIT

    def show_operator?(index, filter_count)
      active? && index < filter_count - 1
    end
  end
end
