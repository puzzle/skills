# encoding: utf-8

# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  role        :text
#  year_from   :integer
#  year_to     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  person_id   :integer
#

class Activity < ApplicationRecord
  belongs_to :person
  validates :year_from, :year_to, :person_id, :role, presence: true
  validates :description, length: { maximum: 1000 }
  validates :role, length: { maximum: 30 }
  validate :year_from_before_year_to

  scope :list, -> { order(:year_from) }
end
