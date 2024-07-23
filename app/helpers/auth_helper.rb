# frozen_string_literal: true

module AuthHelper
  def session_path(_scope)
    new_auth_user_session_path
  end

  def admin?
    current_auth_user&.is_admin
  end

  def conf_admin?
    current_auth_user&.is_conf_admin || false
  end

  def find_person_by_auth_user
    Person.find_by(name: current_auth_user&.name)
  end

  # This method returns true if the user should be authenticated by devise
  def devise?
    AuthConfig.keycloak? || Rails.env.test?
  end

  def language_selector
    languages = I18nData.languages(I18n.locale).to_a.map do |e|
      [e.second.titleize, e.first.downcase.to_sym]
    end
    languages = languages.select { |e| I18n.available_locales.include? e.second }
    options_for_select(languages, I18n.locale)
  end

  def active_locale
    I18n.locale if I18n.locale != I18n.default_locale
  end
end
