# frozen_string_literal: true

class SkillSearchController < CrudController
  def self.model_class = PeopleSkill

  before_action :set_search

  private

  def set_search
    @search = SkillSearch::Search.new(search_params)
    @search.apply_filters
  end

  def search_params
    raw = params.permit(
      :department, :add_row, :delete_row, :expert_mode,
      skill_id: [], level: [], interest: {}, operator: {}
    )
    {
      skill_ids:   raw[:skill_id]&.map(&:to_i),
      levels:      raw[:level]&.map(&:to_i),
      interests:   raw[:interest]&.values&.map(&:to_i),
      operators:   raw[:operator]&.values&.map(&:to_sym),
      department:  raw[:department].presence&.to_i,
      add_row:     raw[:add_row].present?,
      delete_row:  raw[:delete_row].presence&.to_i,
      expert_mode: raw[:expert_mode] == '1'
    }
  end
end
