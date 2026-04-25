# frozen_string_literal: true

class SkillSearchController < CrudController
  def self.model_class = PeopleSkill

  before_action :set_search

  private

  def set_search
    @search = SkillSearch::Search.new(search_params)
    @search.apply_filters
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength -- parameter mapping method; chained .to_a/.to_h/.map calls and safe navigation on optional scalars inflate all three metrics without adding real complexity
  def search_params
    raw = permitted_search_params
    {
      skill_ids: raw[:skill_id].to_a.map(&:to_i),
      levels: raw[:level].to_a.map(&:to_i),
      interests: raw[:interest].to_h.values.map(&:to_i),
      operators: raw[:operator].to_h.values.map(&:to_sym),
      department: raw[:department].presence&.to_i,
      add_row: raw[:add_row].present?,
      delete_row: raw[:delete_row].presence&.to_i,
      expert_mode: raw[:expert_mode] == '1'
    }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

  def permitted_search_params
    params.permit(:department, :add_row, :delete_row, :expert_mode,
                  skill_id: [], level: [], interest: {}, operator: {})
  end
end
