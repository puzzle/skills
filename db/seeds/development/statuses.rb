# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'status_seeder')

seeder = StatusSeeder.new

seeder.seed_statuses(['Mitarbeiter', 'Ex. Mitarbeiter', 'Bewerber', 'Partner'])
