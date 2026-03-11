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

  def editor?
    current_auth_user&.is_editor
  end

  def find_person_by_auth_user
    Person.find_by(name: current_auth_user&.name)
  end

  # This method returns true if the user should be authenticated by devise
  def devise?
    AuthConfig.keycloak? || Rails.env.test?
  end

  def language_selector
    languages = I18n.available_locales.map { |e| e.to_s }.map do |lang_code|
      [language(lang_code).capitalize, url_for(locale: lang_code, set_by_user: true)]
    end
    options_for_select(languages, url_for(locale: I18n.locale, set_by_user: true))
  end

  def language(lang_code)
    if lang_code == 'de-CH'
      'Schwizerdütsch'
    else
      I18nData.languages(lang_code)[lang_code.upcase]
    end
  end
end
