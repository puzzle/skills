# frozen_string_literal: true

module AuthHelper
  def session_path(_scope)
    new_auth_user_session_path
  end

  def admin?
    current_auth_user&.is_admin
  end

  def generate_select_options_with_default(person)
    selected = person ? person.id : ''
    prompt = person ? false : true
    { :selected => selected, :prompt => prompt, :disabled => '' }
  end

  def development?
    ENV['DEVELOPMENT'] == 'true'
  end
end
