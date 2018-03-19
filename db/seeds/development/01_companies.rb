# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'company_seeder')

seeder = CompanySeeder.new

companies = ['PuzzleITC',
         'Ex-Mitarbeiter',
         'Partnerfirma']

seeder.seed_companies(companies)
