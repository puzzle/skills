# frozen_string_literal: true

module AuthHelper
  def session_path(_scope)
    new_auth_user_session_path
  end

  def admin?
    current_auth_user&.is_admin
  end

  def find_person_by_auth_user
    Person.find_by(name: current_auth_user&.name)
  end

  def development?
    ENV['DEVELOPMENT'] == 'true' && Rails.env.development?
  end
end
