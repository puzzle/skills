# frozen_string_literal: true

module SkillSearch
  class NoMatchMessage
    def initialize(filters, department)
      @filters    = filters
      @department = department
    end

    def to_s
      ratings = skill_ratings
      ratings << Department.find(@department).name if @department
      ratings.to_sentence
    end

    private

    def skill_ratings
      skill_titles.zip(levels, interests).map do |title, level, interest|
        "#{title} (#{level}/#{interest})"
      end
    end

    def skill_titles = Skill.find(@filters.map(&:skill_id)).pluck(:title)
    def levels       = @filters.map(&:level)
    def interests    = @filters.map(&:interest)
  end
end
