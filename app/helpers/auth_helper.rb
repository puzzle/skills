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
    # test = I18n.available_locales.map do |locale|
    #   [I18n.t('language.name', locale: locale), locale]
    # end
    test = I18n.available_locales.map do |locale|
      [locale, locale]
    end

    options_for_select(test, I18n.locale)
  end

end
