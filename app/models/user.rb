class User < ApplicationRecord
  validates :ldap_uid, uniqueness: true

  def update_failed_login_attempts
    update_attributes(last_failed_login_attempt_at: Time.now,
                      failed_login_attempts: failed_login_attempts + 1)
  end

  def locked?
    locked_until > Time.now if last_failed_login_attempt_at
  end
  
  def reset_failed_login_attempts
    update_attributes(last_failed_login_attempt_at: nil,
                      failed_login_attempts: 0)
  end

  private

    
  def locked_until
    last_failed_login_attempt_at + (failed_login_attempts*3).seconds
  end

  class << self
    def create_or_find(ldap_uid)
      user = User.find_by(ldap_uid: ldap_uid)
      user ? user : create(ldap_uid)
    end

    private

    def create(ldap_uid)
      user = User.new(ldap_uid: ldap_uid)
      user.api_token = generate_api_token
      user.save!
      user
    end

    def generate_api_token
      SecureRandom.hex(255)
    end
  end
end
