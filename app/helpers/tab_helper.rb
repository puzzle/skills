# frozen_string_literal: true

module TabHelper
  def person_tabs(person)
    [
      { title: 'CV', path: person_path(person) },
      { title: 'Skills', path: person_people_skills_path(person) }
    ]
  end
end
