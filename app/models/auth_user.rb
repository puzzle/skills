# frozen_string_literal: true

class AuthUser < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:keycloak_openid]

  class << self
    def from_omniauth(auth)
      person = where(uid: auth.uid).first_or_create { |user| initialize_user(user, auth) }
      person.last_login = Time.zone.now
      set_admin(person, auth)
    end

    private

    def initialize_user(user, auth)
      user.name = auth.info.name
      user.email = auth.info.email
      user.ldap_username = auth.extra.raw_info.pitc.uid
    end

    def set_admin(person, auth)
      person.is_admin = role?(auth, AuthConfig.admin_role)
      person.is_conf_admin = role?(auth, AuthConfig.conf_admin_role)
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
