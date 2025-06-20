# frozen_string_literal: true

class SkillSearchController < CrudController
  def self.model_class
    PeopleSkill
  end

  def index
    @search_filters, @search_results = FilterParams.new(params).filters_and_results
    super
  end

  # def no_match_message
  #   skill_titles = filter_params.skill_ids.map { |skill_id| Skill.find(skill_id).title }
  #   levels = filter_params.levels
  #   interests = filter_params.interests
  #   combine_to_feedback_sentence(skill_titles, levels, interests)
  # end
  #
  # def combine_to_feedback_sentence(skill_titles, levels, interests)
  #   skill_titles.zip(levels, interests).map do |skill_title, level, interest|
  #     "#{skill_title} (#{level}/#{interest})"
  #   end.to_sentence
  # end
end
