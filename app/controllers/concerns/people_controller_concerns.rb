# frozen_string_literal: true

module PeopleControllerConcerns
  private

  def validate_language_skill_levels
    params[:person][:language_skills_attributes]&.each_value do |language_skill|
      unless %w[Keine A1 A2 B1 B2 C1 C2 Muttersprache].include?(language_skill[:level])
        language_skill[:level] = 'Keine'
      end
    end
  end

  def set_nationality2
    if params.include?(:has_nationality2) && false?(params[:has_nationality2][:checked])
      params[:person][:nationality2] = nil
    end
  end
end
