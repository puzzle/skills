# encoding: utf-8
class AuthUserSeeder
  def seed_auth_users(auth_user_informations)
    auth_user_informations.each do |auth_user_information|
      seed_auth_user(auth_user_information)
    end
  end

  private

  def seed_auth_user(auth_user_information)
    AuthUser.seed_once(:email) do |user|
      user.uid = rand(36**20).to_s(36)
      user.name = auth_user_information[:first_name] + ' ' + auth_user_information[:last_name]
      user.email = auth_user_information[:last_name].downcase + '@skills.ch'
      user.is_admin = auth_user_information[:admin]
    end
  end
end
