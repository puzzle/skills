# encoding: utf-8

class CompanySeeder
  def seed_companies(companies, my_company_flags)
    my_company_flags.reverse!
    
    companies.each do |name|
      flag = my_company_flags.pop
      company = seed_company(name, flag).first
      
      break unless company
      associations = [:location, :employee_quantity, :offer]
      associations.each do |a|
        seed_association(a, company.id)
      end
    end
  end
  
  def seed_association(assoc_name, company_id)
    rand(1..3).times do
      send("seed_#{assoc_name}", company_id)
    end
  end

  private
  
  def seed_company(name, flag)
    Company.seed do |co|
      co.name = name
      co.web = "www.example.com"
      co.email = "info@example.ch"
      co.phone = Faker::PhoneNumber.cell_phone
      co.partnermanager =  Faker::StarTrek.character
      co.contact_person = Faker::StarWars.character
      co.email_contact_person = Faker::Internet.email
      co.phone_contact_person = Faker::PhoneNumber.cell_phone
      co.crm = "crm"
      co.level = ["A", "B", "C", "D", "E", "F"].sample
      co.offer_comment = Faker::Hacker.say_something_smart
      co.my_company = flag
    end
  end

  def seed_location(company_id)
    Location.seed do |a|
      a.location = Faker::Pokemon.location
      a.company_id = company_id
    end
  end
  
  def seed_employee_quantity(company_id)
    EmployeeQuantity.seed do |a|
      category = Faker::Hacker.noun
      a.category = "Total MA #{category}"
      a.quantity = Faker::Number.between(10, 100)
      a.company_id = company_id
    end
  end
  
  def seed_offer(company_id)
    Offer.seed do |a|
      a.category = Faker::Hacker.noun
      a.offer = ["Java", "Ruby", "Javascript", "C++", "C", "C#"]
      a.company_id = company_id
    end
  end
end
