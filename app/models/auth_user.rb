# frozen_string_literal: true

class AuthUser < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:keycloak_openid]

  class << self
    def from_omniauth(auth)
      person = where(uid: auth.uid).first_or_create do |user|
        user.name = auth.info.name
        user.email = auth.info.email
      end
      person.last_login = Time.zone.now
      set_admin(person, auth)
    end

    private

    def set_admin(person, auth)
      person.is_admin = admin?(auth)
      person.save
      person
    end

    def admin?(auth)
      client_roles(auth).include? AuthConfig.admin_role
    end

    def client_roles(auth)
      auth.extra&.raw_info&.resource_access&.[](AuthConfig.client_id)&.roles || []
    end
  end
end
