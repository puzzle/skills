# frozen_string_literal: true

class PeopleSkillsController < CrudController
  include ParamConverters
  include PeopleSkills

  helper_method :search_skill, :search_level, :search_interest, :row_count, :query_params

  def index
    @converted_params = Params.new(params)
    super
  end

  # rubocop:disable Metrics/MethodLength
  def entries
    return [] if params[:skill_id].blank?

    extracted_queries = extract_query_params
    return [] if extracted_queries[:skill_ids].empty?

    base = PeopleSkill.includes(:person, skill: [
                                  :category,
                                  :people, { people_skills: :person }
                                ])
    PeopleSkillsFilter.new(
      base, true, extracted_queries[:levels], extracted_queries[:interests],
      extracted_queries[:skill_ids]
    ).scope
  end
  # rubocop:enable Metrics/MethodLength

  def row_count
    params[:skill_id].present? ? params[:skill_id].length : 1
  end

  # rubocop:disable Metrics/AbcSize
  def extract_query_params
    query_hash = { :skill_ids => [], :levels => [], :interests => [] }
    params[:skill_id].map.with_index do |skill, index|
      next unless skill != ''

      query_hash[:skill_ids] << skill.to_i
      query_hash[:levels] << params[:level][index].to_i
      query_hash[:interests] << params[:interest].values[index].to_i
    end
    query_hash
  end
  # rubocop:enable Metrics/AbcSize
end
