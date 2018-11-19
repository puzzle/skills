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

class Company < ApplicationRecord

  before_destroy :protect_if_my_company

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

  def protect_if_my_company
    if my_company?
      errors.add(:base, 'your own company can not be deleted')
      throw(:abort)
    end
  end

end
