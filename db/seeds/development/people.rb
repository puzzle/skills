# encoding: utf-8
#

require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

seeder = PersonSeeder.new

seeder.seed_people(["Barack Obama", "Angela Merkel"])
seeder.seed_variations(Person.all)
