# == Schema Information
#
# Table name: statuses
#
#  id     :integer          not null, primary key
#  status :string
#

class Status < ApplicationRecord
  has_many :people
  has_many :variations, class_name: Person::Variation
  validates :status, presence: true
  validates_length_of :status, maximum: 30

  scope :list, -> { order(:status) }
end
