class CompanySerializer < ApplicationSerializer

  attributes :id, :name, :web, :email, :phone, :partnermanager, :contact_person,
             :email_contact_person, :phone_contact_person, :crm, :level,
             :my_company, :created_at, :updated_at
  
  has_many :people, include: :all
  has_many :locations, include: :all
  has_many :employee_quantities, include: :all

end
