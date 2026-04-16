# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'auth_user_seeder')

seeder = AuthUserSeeder.new

auth_users = [
  {
    first_name: 'Carl Albrecht', last_name: 'Conf Admin', admin: true, editor: false
  },
  {
    first_name: 'Andreas', last_name: 'Admin', admin: true, editor: false
  },
  {
    first_name: 'Eddy', last_name: 'Editor', admin: false, editor: true
  },
  {
    first_name: 'Ursula', last_name: 'User', admin: false, editor: false
  },
]

seeder.seed_auth_users(auth_users)
