# frozen_string_literal: true

class FilterParams
  def initialize(params)
    @params = params
  end

  def filters_and_results
    filters = search_filters
    results = search_results(filters.filter { |f| f.exclude?(nil) })
    [filters, results]
  end

  DEFAULT_FILTER = [nil, 1, 1].freeze

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

    skill_ids = filters.map(&:first)

    filtered_people = filtered_people_skills(filters)
                      .group('person_id')
                      .having('COUNT(id) = ?', skill_ids.length)
                      .select('person_id')

    department_filter = department ? { person: { department: department } } : {}

    PeopleSkill.includes(:skill, person: :department)
               .where(person_id: filtered_people, skill_id: skill_ids).where(department_filter)
               .order('skills.title').group_by(&:person)
  end

  def filtered_people_skills(filters)
    filters.map do |skill_id, level, interest|
      PeopleSkill.where('skill_id = ? AND level >= ? AND interest >= ?',
                        skill_id, level, interest)
    end.reduce(:or)
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

  def constructed_filters
    skill_ids.map do |id|
      id.presence&.to_i
    end.zip(levels.map(&:to_i), interests.map(&:to_i))[0..4]
  end

  def add_row?
    @params[:add_row].present?
  end

  def delete_row
    @params[:delete_row].presence
  end
end
