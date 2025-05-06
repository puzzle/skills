# frozen_string_literal: true

module LanguageSkillHelper
  def language_skill_svg(level)
    if matching_skill_level('native', level)
      return 'Muttersprache'
    elsif matching_skill_level('none', level)
      return 'Keine'
    end

    level
  end

  private

  def matching_skill_level(translation_to_check, level)
    I18n.available_locales.any? do |locale|
      I18n.t("language_skills.#{translation_to_check}", locale: locale) == level
    end
  end
end