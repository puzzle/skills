# == Schema Information
#
# Table name: advanced_trainings
#
#  id          :integer          not null, primary key
#  description :text
#  updated_by  :string
#  year_from   :integer
#  year_to     :integer
#  person_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class AdvancedTraining < ApplicationRecord
  belongs_to :person
  validates :year_from, :year_to, :person_id, presence: true
  validates_length_of :description, maximum: 1000
  validates_length_of :updated_by, maximum: 30
  validate :start_must_be_before_end_time

  scope :list, -> { order(:year_from) }
end
