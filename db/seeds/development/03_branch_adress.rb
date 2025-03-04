# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'branch_adress_seeder')

seeder = BranchAdressSeeder.new

branch_adress_short_names = ["Bern", "Basel", "Zürich", "Genf", "Chur", "Thun"]

branch_adress_information = [
  "Bielstrasse 1, CH-3006 Bern / Tel. +41 11 111 11 11",
  "Chilegass 1, CH-4001 Basel / Tel. +41 22 222 22 22",
  "Tulpenweg 1, CH-8001 Zürich / Tel. +41 33 333 33 33",
  "Gartenweg 1, CH-1201 Genf / Tel. +41 44 444 44 44",
  "Bettistrasse 1, CH-7000 Chur / Tel. +41 55 555 55 55",
  "Mittelgasse 1, CH-3600 Thun / Tel. +41 66 666 66 66",
]

branch_adress_default_branch_adress = [
  false,
  true,
  false,
  false,
  false,
  false
]

seeder.seed_branch_adresses(branch_adress_short_names, branch_adress_information, branch_adress_default_branch_adress)


