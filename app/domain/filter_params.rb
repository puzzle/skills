# frozen_string_literal: true

class FilterParams
  def initialize(params)
    @params = params
  end

  def filters_and_results
    filters = search_filters
    results = search_results(filters)
    [filters, results]
  end

  private

  def search_filters
    unless skill_ids && levels && interests
      return [default_filter]
    end

    filters = constructed_filters
    filters << default_filter if add_row?
    filters.delete_at(delete_row.to_i) if delete_row

    filters
  end

  def search_results(filters)
    skill_ids, levels, interests = filters.transpose
  end

  def skill_ids
    @params[:skill_id].presence
  end

  def levels
    @params[:level].presence
  end

  def interests
    @params[:interest]&.values.presence
  end

  def constructed_filters
    skill_ids.map(&:to_i).zip(levels.map(&:to_i), interests.map(&:to_i))
  end

  def default_filter
    [Skill.order(:title).first.id, 1, 1]
  end

  def add_row?
    @params[:add_row].present?
  end

  def delete_row
    @params[:delete_row].presence
  end
end
