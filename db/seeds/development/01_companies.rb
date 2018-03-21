# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'company_seeder')

seeder = CompanySeeder.new

companies = ['Firma',
         'Ex-Mitarbeiter',
         'Bewerber',
         'Partner']
         
my_company_flags = [true, false, false, false]

seeder.seed_companies(companies, my_company_flags)
