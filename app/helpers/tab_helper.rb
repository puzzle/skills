# frozen_string_literal: true

module TabHelper
  LOCALE_REGEX = /(\/(?:#{I18n.available_locales.join('|')}))/
  GLOBAL_NAVBAR_REGEX = /^#{LOCALE_REGEX}?(\/[^\/]+)(?:\/|$)/
  PERSON_NAVBAR_REGEX = /^(.*)/

  def person_tabs(person)
    [
      { title: ti('tabbar.cv'), path: person_path(person) },
      { title: ti('tabbar.skills'), path: person_people_skills_path(person) }
    ]
  end

  def global_tabs
    [
      { title: ti('navbar.profile'), path: people_path },
      { title: ti('navbar.skill_search'), path: people_skills_path },
      { title: ti('navbar.cv_search'), path: cv_search_index_path },
      { title: ti('navbar.skillset'), path: skills_path }
    ]
  end

  def extract_path(regex)
    request.path.match(regex)&.captures&.join
  end

  def global_navbar_path
    extract_path(GLOBAL_NAVBAR_REGEX)
  end

  def person_navbar_path
    extract_path(PERSON_NAVBAR_REGEX)
  end
end
