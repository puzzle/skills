# frozen_string_literal: true

module AuthHelper
  def session_path(_scope)
    new_person_session_path
  end

  def admin?
    current_person&.is_admin
  end
end
