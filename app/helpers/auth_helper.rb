# frozen_string_literal: true

module AuthHelper
  def session_path(_scope)
    new_auth_user_session_path
  end

  def admin?
    current_auth_user&.is_admin
  end

  def people_dropdown_config(person)
    selected = person ? person.id : ''
    prompt = person ? false : true
    { :selected => selected, :prompt => prompt, :disabled => '' }
  end
end
