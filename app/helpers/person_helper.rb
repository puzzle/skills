# frozen_string_literal: true

module PersonHelper
  def nationality_string(nationality, nationality2)
    if nationality2.blank?
      ISO3166::Country[nationality].translations[I18n.locale]
    else
      "#{ISO3166::Country[nationality].translations[I18n.locale]},
        #{ISO3166::Country[nationality2].translations[I18n.locale]}"
    end
  end

  def person_role_string(person_role)
    "#{person_role.role.name} #{person_role.person_role_level&.level}
      #{person_role.percent.nil? ? '' : "#{person_role.percent.to_i}%"}"
  end

  def marital_status_translation_map
    Person.marital_statuses.keys.map do |marital_status|
      [marital_status, t("marital_statuses.#{marital_status}")]
    end
  end

  def country_alpha2_translation_map
    ISO3166::Country.all.sort.map do |country|
      [country.alpha2, country.translations[I18n.locale]]
    end
  end

  # If the path of the avatar includes tmp, the picture is cached
  # and we can load it directly without the picture controller
  def avatar_cached?(picture)
    picture&.file&.file&.include? 'tmp'
  end

  def group_person_skills_by_category(person)
    PeopleSkill.core_competence.where(person_id: person.id)
               .group_by { |ps| ps.skill.category.parent }
  end

  def common_languages_translated
    I18nData.languages('DE').collect do |language|
      if LanguageList::LanguageInfo.find(language[0])&.common?
        [language.first, "#{language.last} (#{language.first})"]
      end
    end.compact.sort_by(&:last)
  end

  def sort_languages(languages)
    mandatory_langs, optional_langs = languages.partition do |language|
      uneditable_language?(language.language)
    end
    mandatory_langs.sort_by(&:language) + optional_langs.sort_by(&:language)
  end

  def uneditable_language?(lang)
    %w[DE EN FR].include?(lang)
  end

  def language_skill_levels
    %w[Keine A1 A2 B1 B2 C1 C2 Muttersprache]
  end

  def people_skills_of_category(category)
    @people_skills.where(skill_id: category.skills.pluck(:id)).sort_by(&:id)
  end

  def not_rated_default_skills(person)
    rated_skills = person.skills
    not_rated_default_skills = Skill.all.filter do |skill|
      skill.default_set && rated_skills.exclude?(skill)
    end

    not_rated_default_skills.map do |skill|
      PeopleSkill.new({ person_id: person.id, skill_id: skill.id, level: 1, interest: 1,
                        certificate: false, core_competence: false })
    end
  end
end
