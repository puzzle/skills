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
#  picture               :string
#  my_company            :boolean

class Company < ApplicationRecord
  has_many :people
  has_many :locations, dependent: :destroy
  has_many :employee_quantities, dependent: :destroy
  
  mount_uploader :picture, PictureUploader

  validate :picture_size
  validates :name, :my_company, presence: true
  validates :name, :web, :email, :phone, :partnermanager, :contact_person, 
            :email_contact_person, :phone_contact_person, :crm, :level, length: { maximum: 100 }


  private
  def picture_size
    return if picture.nil? || picture.size < 10.megabytes
    errors.add(:picture, 'grösse kann maximal 10MB sein')
  end
end
