# frozen_string_literal: true

module TabHelper
  LOCALE_REGEX = /(\/(?:#{I18n.available_locales.join('|')}))/
  GLOBAL_NAVBAR_REGEX = /^#{LOCALE_REGEX}?(\/[^\/]+)(?:\/|$)/
  PERSON_NAVBAR_REGEX = /^(.*)/

  def person_tabs(person)
    [
      { title: ti('tabbar.cv'), path: person_path(person), admin_only: false },
      { title: ti('tabbar.skills'), path: person_people_skills_path(person), admin_only: false }
    ]
  end

  # rubocop:disable Metrics/LineLength
  def global_tabs
    [
      { title: ti('navbar.profile'), path: people_path, admin_only: false },
      { title: ti('navbar.skill_search'), path: skill_search_index_path, admin_only: false },
      { title: ti('navbar.cv_search'), path: cv_search_index_path, admin_only: false },
      { title: ti('navbar.skillset'), path: skills_path, admin_only: false },
      { title: ti('navbar.certificates'), path: certificates_path, admin_only: true },
      { title: ti('navbar.skills_tracking'), path: department_skill_snapshots_path, admin_only: false }
    ]
  end
  # rubocop:enable Metrics/LineLength

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
