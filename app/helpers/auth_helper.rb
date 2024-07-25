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

  def ptime_available?
    ActiveModel::Type::Boolean.new.cast(ENV.fetch('PTIME_API_ACCESSIBLE', true))
  end

  def language_selector
    languages = I18n.available_locales.map { |e| e.to_s }.map do |lang_code|
      language = I18nData.languages(lang_code)[lang_code.upcase]
      [language.capitalize, url_for(locale: lang_code)]
    end
    options_for_select(languages, url_for(locale: I18n.locale))
  end
end
