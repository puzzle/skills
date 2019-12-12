require Rails.root.join('db', 'seeds', 'support', 'person_role_level_seeder')

seeder = PersonRoleLevelSeeder.new

person_role_levels = ['Keine',
                       'S1',
                       'S2',
                       'S3',
                       'S4',
                       'S5',
                       'S6']

seeder.seed_person_role_levels(person_role_levels)
