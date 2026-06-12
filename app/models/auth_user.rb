# frozen_string_literal: true

class AuthUser < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:keycloak_openid]

  has_one :person, dependent: :restrict_with_error

  class << self
    def from_omniauth(auth)
      person = where(uid: auth.uid).first_or_create { |user| initialize_user(user, auth) }
      person.last_login = Time.zone.now
      person_to_update = Person.find_by(email: person.email)
      person_to_update.update(auth_user_id: person.id) if person_to_update && !person_to_update.auth_user_id
      set_ldap_username(person, auth)
      set_role(person, auth)
    end

    private

    def initialize_user(user, auth)
      user.name = auth.info.name
      user.email = auth.info.email
    end

    def set_ldap_username(person, auth)
      raw_info = auth.extra&.raw_info
      person.ldap_username = raw_info&.pitc&.uidd
    end

    def set_role(person, auth)
      person.is_admin = role?(auth, AuthConfig.admin_role)
      person.is_editor = role?(auth, AuthConfig.editor_role)
      person.save
      person
    end

    def role?(auth, role)
      client_roles(auth).include? role
    end

    # rubocop:disable Style/SafeNavigationChainLength
    def client_roles(auth)
      auth.extra&.raw_info&.resource_access&.[](AuthConfig.client_id)&.roles || []
    end
    # rubocop:enable Style/SafeNavigationChainLength
  end
end
