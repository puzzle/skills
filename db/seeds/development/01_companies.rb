# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'company_seeder')

seeder = CompanySeeder.new

companies = ['Company',
         'Former employee',
         'Applicant',
         'Partner']

seeder.seed_companies(companies)
