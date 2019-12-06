require Rails.root.join('db', 'seeds', 'support', 'person_role_level_seeder')

seeder = PersonRoleLevelSeeder.new

seeder.seed_person_role_levels(Settings.person_role_levels)
