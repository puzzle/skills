# encoding: utf-8
#

require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

seeder = PersonSeeder.new

names = ["Jorah Mormont",
         "Tyrion Lannister",
         "Stannis Baratheon",
         "Varys",
         "Gendry",
         "Gregor Clegane",
         "Jon Snow",
         "Cersei Lannister",
         "Samwell Tarly",
         "Ned Stark",
         "Melisandre",
         "Theon Greyjoy",
         "Jaqen H'ghar",
         "Jaime Lannister",
         "Joffrey Baratheon",
         "Sandor Clegane",
         "Bronn",
         "Daenerys Targaryen",
         "Davos Seaworth",
         "Arya Stark"]



seeder.seed_people(names)

Person.all.each do |p|
  rand(0..3).times do
    seeder.seed_variation(p)
  end
end
