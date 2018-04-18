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
#  offer_comment         :string
#  my_company            :boolean

class Company < ApplicationRecord
  
  before_destroy :check_if_my_company
  
  has_many :people, dependent: :nullify
  has_many :locations, dependent: :destroy
  has_many :employee_quantities, dependent: :destroy
  has_many :offers, dependent: :destroy

  validates :name, presence: true
  validates :name, :web, :email, :phone, :partnermanager, :contact_person,
            :email_contact_person, :phone_contact_person, :crm, :level, length: { maximum: 100 }
  validates :offer_comment, length: { maximum: 500 }          
  
  scope :list, -> { order('name asc') }
  
  private
  
  def check_if_my_company
    if my_company
      errors.add(:base, 'your own company can not be deleted')
      throw(:abort)
    end
  end
  
end
