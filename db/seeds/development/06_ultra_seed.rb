# encoding: utf-8

require 'faker'

require Rails.root.join('db', 'seeds', 'support', 'auth_user_seeder')
require Rails.root.join('db', 'seeds', 'support', 'company_seeder')
require Rails.root.join('db', 'seeds', 'support', 'branch_adress_seeder')
require Rails.root.join('db', 'seeds', 'support', 'certificate_seeder')
require Rails.root.join('db', 'seeds', 'support', 'department_skill_snapshot_seeder')
require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

# ==============================================================================
# SEEDING CONFIGURATION (MULTIPLIERS)
# Passen Sie diese Werte an, um die generierte Datenmenge zu steuern.
# ==============================================================================
CONFIG = {
  companies: 600,
  auth_users: 300,
  certificates_factor: 20, # Ergibt: factor * 20 (Standard im Seeder)
  skills: 600,
  people: 1000
}.freeze

# ==============================================================================
# HELPER METHODS
# ==============================================================================

def seed_companies(count)
  puts "-> Seeding #{count} extra companies..."
  seeder = CompanySeeder.new

  begin
    names = count.times.map { Faker::Company.unique.name }
  rescue Faker::UniqueGenerator::RetryLimitExceeded
    Faker::Company.unique.clear
    names = count.times.map { "#{Faker::Company.name} #{rand(1000..9999)}" }.uniq
  end

  seeder.seed_companies(names)
end

def seed_departments
  puts "-> Seeding specific extra departments..."
  departments = [
    "/dev/cloud", "/dev/mobile", "/dev/ai", "/dev/security", "/dev/devops",
    "/dev/frontend", "/dev/backend", "/dev/data", "/dev/infra", "/dev/qa",
    "/marketing/digital", "/marketing/content", "/marketing/seo", "/marketing/pr",
    "/sales/dach", "/sales/international", "/sales/b2b", "/sales/b2c",
    "/hr/recruiting", "/hr/operations", "/hr/development",
    "/finance/accounting", "/finance/controlling", "/finance/payroll",
    "/legal/compliance", "/legal/contracts", "/legal/ip",
    "/support/tier1", "/support/tier2", "/support/tier3",
    "/consulting/agile", "/consulting/strategy", "/consulting/tech",
    "/management/c-level", "/management/board",
    "/research/innovation", "/research/labs",
    "/quality_assurance/manual", "/quality_assurance/automation",
    "/operations"
  ]
  departments.each { |name| Department.seed(name: name) }
end

def seed_auth_users(count)
  puts "-> Seeding #{count} extra auth users..."
  seeder = AuthUserSeeder.new
  Faker::Name.unique.clear

  users = count.times.map do |i|
    {
      first_name: Faker::Name.first_name,
      last_name: "#{Faker::Name.last_name}#{i}",
      admin: [true, false, false, false, false, false].sample,
      editor: [true, false, true, false, false].sample
    }
  end
  seeder.seed_auth_users(users)
end

def seed_branch_addresses
  puts "-> Seeding extra branch addresses..."
  seeder = BranchAdressSeeder.new
  cities = [
    "Lugano", "Luzern", "St. Gallen", "Winterthur", "Baden", "Olten", "Neuchâtel",
    "Fribourg", "Sion", "Bellinzona", "Aarau", "Schaffhausen", "Chur", "Uster",
    "Frauenfeld", "Vernier", "Lancy", "Yverdon-les-Bains", "Zug", "Kriens",
    "Rapperswil-Jona", "Montreux", "Dietikon", "Wetzikon", "Baar", "Meyrin",
    "Carouge", "Kreuzlingen", "Biel/Bienne", "Thun"
  ]

  info = cities.map do |city|
    "#{Faker::Address.street_name} #{Faker::Address.building_number}, CH-#{Faker::Address.zip_code} #{city} / Tel. +41 #{rand(10..99)} #{rand(111..999)} #{rand(11..99)} #{rand(11..99)}"
  end

  defaults = Array.new(cities.size, false)
  seeder.seed_branch_adresses(cities, info, defaults)
end

def seed_certificates(factor)
  # Standard im CertificateSeeder ist 20. Wir rufen ihn factor-mal auf.
  total = factor * 20
  puts "-> Seeding #{total} extra certificates..."
  seeder = CertificateSeeder.new
  factor.times { seeder.seed_certificates }
end

def seed_skills(count)
  puts "-> Seeding #{count} extra skills..."
  suffixes = %w[Basics Advanced Expert Architecture Patterns Management Security Automation Framework Engineering Operations Design Strategy Analysis]
  prefixes = %w[Cloud Data Web Mobile Enterprise Agile System Network Frontend Backend]

  count.times do
    title = "#{prefixes.sample} #{Faker::Job.key_skill} #{suffixes.sample}".strip
    Skill.seed_once(:title) do |s|
      s.title = title
      s.radar = rand(0..3)
      s.portfolio = rand(0..2)
      s.default_set = rand(1..3) > 1
      s.category = Category.all_children.sample
    end
  end
end

    def seed_people(count)
      puts "-> Seeding #{count} extra people (this will generate deep associations!)..."
      seeder = PersonSeeder.new
      names = count.times.map { |i| "#{Faker::Name.first_name} #{Faker::Name.last_name} #{i}" }
      seeder.seed_people(names)
    end

    def seed_snapshots
      puts "-> Seeding historical department skill snapshots (this might take a while)..."
      DepartmentskillSnapshotSeeder.new.seed_department_skill_snapshots
    end

    # ==============================================================================
    # MAIN EXECUTION
    # ==============================================================================
    puts "=========================================================="
    puts "Starting Massive Seeding Process"
    puts "=========================================================="

    seed_companies(CONFIG[:companies])
    seed_departments
    seed_auth_users(CONFIG[:auth_users])
    seed_branch_addresses
    seed_certificates(CONFIG[:certificates_factor])
    seed_skills(CONFIG[:skills])
    seed_people(CONFIG[:people])
    seed_snapshots

    puts "=========================================================="
    puts "Massive Seeding Completed Successfully!"
    puts "=========================================================="