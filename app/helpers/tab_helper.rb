# frozen_string_literal: true

module TabHelper
  PROFILE_REGEX = %r{/[a-z]{2}/people/\d+}

  def person_tabs(person)
    [
      { title: ti('tabbar.cv'), path: person_path(person) },
      { title: ti('tabbar.skills'), path: person_people_skills_path(person) }
    ]
  end

  def global_tabs
    [
      { title: ti('navbar.profile'), path: person_path(find_person_by_auth_user),
        regex: PROFILE_REGEX },
      { title: ti('navbar.skill_search'), path: skill_search_index_path },
      { title: ti('navbar.cv_search'), path: cv_search_index_path },
      { title: ti('navbar.skillset'), path: skills_path },
      { title: ti('navbar.certificates'), path: certificates_path, admin_only: true },
      { title: ti('navbar.skills_tracking'), path: department_skill_snapshots_path }
    ]
  end

  def extract_path(tabs)
    tabs.select do |tab|
      if tab[:regex]
        request.path.match?(tab[:regex])
      else
        request.path.starts_with?(tab[:path])
      end
    end.pluck(:path).max_by(&:length)
  end

  def global_navbar_path
    extract_path(global_tabs)
  end

  def person_navbar_path(person)
    extract_path(person_tabs(person))
  end
end
