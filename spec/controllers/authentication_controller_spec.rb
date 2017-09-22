require 'rails_helper'

describe AuthenticationController do
  describe 'sign in' do
    it 'responses unauthorized if no username param entered' do
      process :sign_in, method: :post, params: { password: 'test' }
      expect(response.status).to eq(401)
    end

    it 'responses unauthorized if no password param entered' do
      process :sign_in, method: :post, params: { username: 'test' }
      expect(response.status).to eq(401)
    end

    it 'responses unauthorized if username contains special chars' do
      process :sign_in, method: :post, params: { username: "special_chars'", password: 'test' }
      expect(response.status).to eq(401)
    end

    it 'responses unauthorized if username does not exist in on Ldap server' do
      allow(LdapTools).to receive(:exists?).and_return(false)

      process :sign_in, method: :post, params: { username: 'unknownUser', password: 'test' }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['error']).to eq('Ungültige Login Daten')
    end

    it 'responses unauthorized if still locked' do
      ken = users(:ken)
      ken.update_attributes(failed_login_attempts: 5,
                            last_failed_login_attempt_at: Time.current)

      allow(LdapTools).to receive(:exists?).and_return(true)

      process :sign_in, method: :post, params: { username: 'kanderson', password: 'test' }

      expect(response.status).to eq(401)
      expect(JSON.parse(response.body)['error']).to eq("User ist gesperrt für 25 Sekunden")
    end

    it 'resets failed login attemtpts &
        api_token and returns ldap_uid and api_token if valid login' do
      ken = users(:ken)
      old_token = ken.api_token
      ken.update_attributes(failed_login_attempts: 5,
                            last_failed_login_attempt_at: Time.current - 30.seconds)

      allow(LdapTools).to receive(:exists?).and_return(ken.ldap_uid)
      allow(LdapTools).to receive(:authenticate).and_return(true)

      process :sign_in, method: :post, params: { username: 'kanderson', password: 'test' }

      ken.reload
      ken_json = JSON.parse(response.body)

      expect(ken.api_token).not_to eq(old_token)
      expect(ken_json['user_id']).to eq(ken.id)
      expect(ken_json['ldap_uid']).to eq(ken.ldap_uid)
      expect(ken_json['api_token']).to eq(ken.api_token)
      expect(ken.failed_login_attempts).to eq(0)
      expect(ken.last_failed_login_attempt_at).to eq(nil)
    end

    it 'creates new user if uid does not exist' do
      allow(LdapTools).to receive(:exists?).and_return(true)
      allow(LdapTools).to receive(:authenticate).and_return(true)

      process :sign_in, method: :post, params: { username: 'newUser', password: 'test' }

      expect(User.exists?(ldap_uid: 'newUser')).to be true
    end

    it 'updates failed login attempts on invalid login' do
      ken = users(:ken)
      allow(LdapTools).to receive(:exists?).and_return(true)
      allow(LdapTools).to receive(:authenticate).and_return(false)

      process :sign_in, method: :post, params: { username: 'kanderson', password: 'test' }

      ken.reload

      expect(ken.failed_login_attempts).to eq(1)
      expect(ken.last_failed_login_attempt_at.nil?).to eq(false)
    end

    it 'does not return api_token on invalid login' do
      allow(LdapTools).to receive(:exists?).and_return(true)
      allow(LdapTools).to receive(:authenticate).and_return(false)

      process :sign_in, method: :post, params: { username: 'kanderson', password: 'test' }

      json = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(json['error']).to eq('Ungültige Login Daten')
    end

  end
end
