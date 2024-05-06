# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'auth_user_seeder')

seeder = AuthUserSeeder.new

auth_users = [
  {
    first_name: 'Andreas', last_name: 'Admin', admin: true
  },
  {
    first_name: 'Ursula', last_name: 'User', admin: false
  }
]

seeder.seed_auth_users(auth_users)
