# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'company_seeder')

seeder = CompanySeeder.new

companies = ['Firma',
         'Ex-Mitarbeiter',
         'Bewerber',
         'Partner']
         
company_types = [0, 2, 1, 3]

seeder.seed_companies(companies, company_types)
