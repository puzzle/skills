# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'certificate_seeder')

CertificateSeeder.new.seed_certificates