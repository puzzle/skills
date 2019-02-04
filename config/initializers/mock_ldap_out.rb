require 'ldap_tools'
module LdapToolsTestMock
  extend ActiveSupport::Concern
  included do
    def self.authenticate(username, password)
      username == 'ken' && password == 'password'
    end

    def self.exists?(username)
      username == 'ken'
    end

    def self.find_user(username)
      {cn: ["ken"]}
    end
  end
end

# This initializer is used for the frontend acceptance login test.

if Rails.env.test? & ENV['MOCK_LDAP_AUTH']
  LdapTools.send :include, LdapToolsTestMock
end
