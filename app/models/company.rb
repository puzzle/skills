# == Schema Information
#
# Table name: companies
#
#  id                    :integer          not null, primary key
#  name                  :string
#  web                   :string
#  email                 :string
#  phone                 :string
#  partnermanager        :string
#  contact_person        :string
#  email_contact_person  :string
#  phone_contact_person  :string
#  crm                   :string
#  level                 :string
#  my_company            :boolean

class Company < ApplicationRecord
  has_many :people, dependent: :nullify
  has_many :locations, dependent: :destroy
  has_many :employee_quantities, dependent: :destroy

  validates :name, presence: true
  validates :name, :web, :email, :phone, :partnermanager, :contact_person,
            :email_contact_person, :phone_contact_person, :crm, :level, length: { maximum: 100 }

end
