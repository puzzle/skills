# frozen_string_literal: true

module SkillSearch
  class SearchFilter
    attr_reader :skill_id, :level, :interest, :operator

    def initialize(skill_id = nil, level = 1, interest = 1, operator = :and) # rubocop:disable Metrics/ParameterLists
      @skill_id = skill_id if skill_id&.positive?
      @level    = level
      @interest = interest
      @operator = operator || :and
    end

    def skill? = skill_id.present?
    def or? = operator == :or

    def match?(skill)
      return false if skill.skill_id != skill_id
      return false if skill.level < level
      return false if skill.interest < interest

      true
    end

    def self.group_match?(group, skills)
      group.all? { |filter| filter.match_any?(skills) }
    end

    def match_any?(skills)
      skills.any? { |skill| match?(skill) }
    end
  end
end
