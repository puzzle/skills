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
  validates_length_of :description, maximum: 1000
  validates_length_of :updated_by, :role, maximum: 30
  validate :start_must_be_before_end_time

  scope :list, -> { order(:year_from) }
end
