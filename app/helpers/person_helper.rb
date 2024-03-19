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
      [language.first, "#{language.last} (#{language.first})"] if LanguageList::LanguageInfo.find(language[0])&.common?
    end.compact.sort_by(&:last)
  end

  def uneditable_language?(lang)
    %w[DE EN FR].include?(lang)
  end

  def add_missing_mandatory_langs(form)
    %w[DE EN FR].each do |language|
      unless form.object.language_skills.map { |lang| lang.language }.include?(language)
        form.object.language_skills.create({ language: language })
      end
    end
  end
end
