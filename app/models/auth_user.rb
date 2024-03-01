# frozen_string_literal: true

class AuthUser < ApplicationRecord

  devise :omniauthable, omniauth_providers: [:keycloak_openid]


  class << self
    def from_omniauth(auth)
      person = where(email: auth.info.email).first_or_create do |user|
        user.name = auth.info.name

      end
      set_admin(person, auth)
    end

    private

    def set_admin(person, auth)
      person.is_admin = admin?(auth)
      person.save
      person
    end

    def admin?(auth)
      resources = auth.extra.raw_info.resource_access[AuthConfig.client_id]
      resources.roles.include? AuthConfig.admin_role
    end
  end
end
