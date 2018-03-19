# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'company_seeder')

seeder = CompanySeeder.new

companies = ['Firma',
         'Ex-Mitarbeiter',
         'Partnerfirma']

seeder.seed_companies(companies)
