# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'company_seeder')

seeder = CompanySeeder.new

companies = ['Firma',
         'Ex-Mitarbeiter',
         'Bewerber',
         'Partner']

seeder.seed_companies(companies)
