class User < ApplicationRecord
  validates :ldap_uid, uniqueness: true

  def update_failed_login_attempts
    update_attributes(last_failed_login_attempt_at: Time.current,
                      failed_login_attempts: failed_login_attempts + 1)
  end

  def locked?
    return locked_until > Time.current if last_failed_login_attempt_at
    false
  end

  def reset_failed_login_attempts
    update_attributes(last_failed_login_attempt_at: nil,
                      failed_login_attempts: 0)
  end

  def seconds_locked
    return 0 if failed_login_attempts <= 3
    (failed_login_attempts * 5).seconds
  end

  private

  def locked_until
    last_failed_login_attempt_at + seconds_locked
  end

  class << self
    def authenticate(username, password)
      return { error: 'authentication failed' } unless LdapTools.exists?(username)

      user = find_or_create(username)

      return { error: { seconds_locked: user.seconds_locked } } if user.locked?

      unless LdapTools.authenticate(username, password)
        user.update_failed_login_attempts
        return { error: 'authentication failed' }
      end

      user.reset_failed_login_attempts
      { ldap_uid: username, api_token: user.api_token }
    end

    def find_or_create(ldap_uid)
      user = User.find_by(ldap_uid: ldap_uid)
      return User.create(ldap_uid: ldap_uid) unless user
      user.update_attributes(api_token: generate_api_token)
      user
    end

    private

    def generate_api_token
      SecureRandom.hex(255)
    end
  end
end
