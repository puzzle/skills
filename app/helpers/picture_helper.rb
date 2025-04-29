# frozen_string_literal: true

module PictureHelper
  def language_skill_svg(level)
    native = I18n.available_locales.any? do |locale|
      I18n.t('language_skills.native', locale: locale) == level
    end
    none = I18n.available_locales.any? do |locale|
      I18n.t('language_skills.none', locale: locale) == level
    end
    if native
      return 'muttersprache'
    elsif none
      return 'keine'
    end
    level
  end
end
