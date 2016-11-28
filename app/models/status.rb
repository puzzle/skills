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

  scope :list, -> { order(:status) }
end
