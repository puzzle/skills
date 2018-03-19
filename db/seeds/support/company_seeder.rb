# encoding: utf-8

class CompanySeeder
  def seed_companies(companies)
    companies.each do |company|
      seed_company(company)
    end
  end

  private
  def seed_company(company)
    Company.seed do |co|
      co.name = company
      co.web = "www.example.com"
      co.location = Faker::Pokemon.location
      co.email = "info@example.ch"
      co.phone = Faker::PhoneNumber.cell_phone
      co.partnermanager =  Faker::StarTrek.character
      co.contact_person = Faker::StarWars.character
      co.email_contact_person = Faker::Internet.email
      co.phone_contact_person = Faker::PhoneNumber.cell_phone
      co.crm = "crm"
      co.level = Faker::Lorem.characters(1)
      co.number_MA_dev = Faker::Number.between(0, 80)
      co.number_MA_sys_mid = Faker::Number.between(0, 80)
      co.number_MA_PL = Faker::Number.between(0, 80)
      co.number_MA_UX = Faker::Number.between(0, 80)
      co.number_MA_total = Faker::Number.between(80, 200)
    end
  end
end
