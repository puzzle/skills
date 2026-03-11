# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

seeder = PersonSeeder.new

names = ['Jorah Mormont',
         'Tyrion Lannister',
         'Stannis Baratheon',
         'Varys',
         'Gendry',
         'Gregor Clegane',
         'Jon Snow',
         'Cersei Lannister',
         'Samwell Tarly',
         'Ned Stark',
         'Melisandre',
         'Theon Greyjoy',
         "Jaqen H'ghar",
         'Jaime Lannister',
         'Joffrey Baratheon',
         'Sandor Clegane',
         'Bob Stark',
         'Daenerys Targaryen',
         'Davos Seaworth',
         'Arya Stark',
         'Andreas Admin',
         'Ursula User',
         'Eddy Editor',
         'Carl Albrecht Conf Admin']

seeder.seed_people(names)
