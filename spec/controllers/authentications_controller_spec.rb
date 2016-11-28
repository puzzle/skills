require 'rails_helper'

describe AuthenticationsController do
  describe 'sign in' do
    it 'responses unauthorized if no username param entered' do
      process :sign_in, method: :post, params: { password: 'test' }
      expect(response.status).to eq(401)
    end

    it 'responses unauthorized if no password param entered' do
      process :sign_in, method: :post, params: { username: 'test' }
      expect(response.status).to eq(401)
    end

    it 'responses unauthorized if username does not exist in on Ldap server' do
      allow(LdapTools).to receive(:uid_by_username).and_return(nil)

      process :sign_in, method: :post, params: { username: 'unknown_user', password: 'test' }

      expect(response.status).to eq(401)
    end

    it 'responses unauthorized if still locked' do
      ken = users(:ken)
      ken.update_attributes(failed_login_attempts: 5,
                            last_failed_login_attempt_at: Time.now)

      allow(LdapTools).to receive(:uid_by_username).and_return(ken.ldap_uid)

      process :sign_in, method: :post, params: { username: 'ken', password: 'test' }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['error']).to eq('user locked')
    end

    it 'resets failed login attemtpts and return user ldap_uid and api_token if valid login' do
      ken = users(:ken)
      ken.update_attributes(failed_login_attempts: 5,
                            last_failed_login_attempt_at: Time.now - 30.seconds)

      allow(LdapTools).to receive(:uid_by_username).and_return(ken.ldap_uid)
      allow(LdapTools).to receive(:valid_user?).and_return(true)

      process :sign_in, method: :post, params: { username: 'ken', password: 'test' }

      ken.reload
      ken_json = JSON.parse(response.body)['user']

      expect(ken_json['ldap_uid']).to eq(ken.ldap_uid)
      expect(ken_json['api_token']).to eq(ken.api_token)
      expect(ken.failed_login_attempts).to eq(0)
      expect(ken.last_failed_login_attempt_at).to eq(nil)
    end

    it 'creates new user if uid does not exist' do
      allow(LdapTools).to receive(:uid_by_username).and_return(2222)
      allow(LdapTools).to receive(:valid_user?).and_return(true)

      process :sign_in, method: :post, params: { username: 'new_user', password: 'test' }

      expect(User.exists?(ldap_uid: 2222)).to eq(true)
    end

    it 'updates failed login attempts on invalid login' do
      ken = users(:ken)
      allow(LdapTools).to receive(:uid_by_username).and_return(ken.ldap_uid)
      allow(LdapTools).to receive(:valid_user?).and_return(false)

      process :sign_in, method: :post, params: { username: 'ken', password: 'test' }

      ken.reload

      expect(ken.failed_login_attempts).to eq(1)
      expect(ken.last_failed_login_attempt_at.nil?).to eq(false)
    end

    it 'does not return api_token on invalid login' do
      allow(LdapTools).to receive(:uid_by_username).and_return(222)
      allow(LdapTools).to receive(:valid_user?).and_return(false)

      process :sign_in, method: :post, params: { username: 'ken', password: 'test' }

      expect(response.body.present?).to eq(false)
    end
  end
end
