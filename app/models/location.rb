# == Schema Information
#
# Table name: locations
#
#  id                    :integer          not null, primary key
#  location              :string
#  company_id            :integer

class Location < ApplicationRecord
  belongs_to :company
  
  validates :location, presence: true
  validates :location, length: { maximum: 100 }
end
