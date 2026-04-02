# frozen_string_literal: true

class FilterParams
  def initialize(params)
    @params = params
  end

  def filters_and_results
    filters = search_filters
    results = search_results(filters.reject { |f| f.include?(nil) })
    [filters, results]
  end

  DEFAULT_FILTER = [nil, 1, 1, :and].freeze

  private

  def search_filters
    return [DEFAULT_FILTER] unless skill_ids && levels && interests

    filters = constructed_filters
    filters << DEFAULT_FILTER if add_row?
    filters.delete_at(delete_row.to_i) if delete_row

    filters
  end

  def search_results(filters)
    return [] unless filters.any?

    people = people_by_skill_ids(filters)

    results = people.select { |_, skills| matches_filters?(skills, filters) }

    if department
      results = results.select do |person, _|
        person.department_id.to_s == department.to_s
      end
    end

    results
  end

  def people_by_skill_ids(filters)
    skill_ids = filters.map(&:first)
    PeopleSkill.includes(:skill, person: :department)
               .where(skill_id: skill_ids)
               .group_by(&:person)
  end

  def matches_filters?(skills, filters)
    groups = []
    current_group = []

    filters.each_with_index do |(skill_id, level, interest, operator), index|
      current_group << [skill_id, level, interest]

      if operator == :or || index == filters.size - 1
        groups << current_group
        current_group = []
      end
    end

    matching_group_filters?(groups, skills)
  end

  def matching_group_filters?(groups, skills)
    groups.any? do |group|
      group.all? do |skill_id, level, interest|
        skills.any? do |ps|
          ps.skill_id == skill_id &&
            ps.level >= level &&
            ps.interest >= interest
        end
      end
    end
  end

  def skill_ids
    @params[:skill_id].presence
  end

  def levels
    @params[:level].presence
  end

  def department
    @params[:department].presence
  end

  def interests
    @params[:interest]&.values.presence
  end

  def operators
    operators = @params[:operator] || {}
    operators.values.map { it.downcase.to_sym }
  end

  def constructed_filters
    skill_ids.map.with_index do |id, i|
      [
        id.presence&.to_i,
        levels[i].to_i,
        interests[i].to_i,
        operators[i] || :and
      ]
    end[0..4]
  end

  def add_row?
    @params[:add_row].present?
  end

  def delete_row
    @params[:delete_row].presence
  end
end
