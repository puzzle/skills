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
  validates :year_from, :year_to, :person_id, :description, presence: true
  validates :description, length: { maximum: 1000 }
  validate :year_from_before_year_to

  scope :list, -> { order(:year_from) }
end
