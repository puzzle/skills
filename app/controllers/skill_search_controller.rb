# frozen_string_literal: true

class SkillSearchController < CrudController
  def self.model_class
    PeopleSkill
  end

  def index
    @search_filters, @search_results = FilterParams.new(params).filters_and_results
    @no_match_message = no_match_message
    super
  end

  private

  def no_match_message
    skill_ids, levels, interests = @search_filters.transpose
    if @search_results.empty? && skill_ids.any?(&:present?)
      skill_titles = Skill.find(skill_ids).pluck(:title)
      combine_to_feedback_sentence(skill_titles, levels, interests)
    end
  end

  def combine_to_feedback_sentence(skill_titles, levels, interests)
    skill_ratings = skill_titles.zip(levels, interests).map do |skill_title, level, interest|
      "#{skill_title} (#{level}/#{interest})"
    end
    department = params[:department].presence
    skill_ratings << Department.find(department).name if department
    skill_ratings.to_sentence
  end
end
