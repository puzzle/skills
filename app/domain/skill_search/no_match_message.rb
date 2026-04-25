# frozen_string_literal: true

module SkillSearch
  class NoMatchMessage
    def initialize(filters, department)
      @filters    = filters
      @department = department
    end

    def prefix
      if @department
        I18n.t('skill_search.global.no_match_with_department',
               department: Department.find(@department).name)
      else
        I18n.t('skill_search.global.no_match')
      end
    end

    def groups
      filter_groups.map { |group| skill_ratings_for(group) }
    end

    private

    def filter_groups
      @filters.slice_after(&:or?)
    end

    def skill_ratings_for(group)
      skill_map = Skill.where(id: group.map(&:skill_id)).index_by(&:id)
      group.map { |f| "#{skill_map[f.skill_id].title} (#{f.level}/#{f.interest})" }
    end
  end
end
