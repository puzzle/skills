# == Schema Information
#
# Table name: companies
#
#  id                      :bigint(8)        not null, primary key
#  name                    :string
#  web                     :string
#  email                   :string
#  phone                   :string
#  partnermanager          :string
#  contact_person          :string
#  email_contact_person    :string
#  phone_contact_person    :string
#  offer_comment           :string
#  crm                     :string
#  level                   :string
#  my_company              :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  associations_updatet_at :datetime
#

class CompanySerializer < ApplicationSerializer

  attributes :id, :name, :web, :email, :phone, :partnermanager, :contact_person,
             :email_contact_person, :phone_contact_person, :crm, :level, :offer_comment,
             :my_company, :created_at, :updated_at

  has_many :people, serializer: PersonInCompanySerializer
  has_many :locations, include: :all
  has_many :employee_quantities, include: :all
  has_many :offers, include: :all

end
