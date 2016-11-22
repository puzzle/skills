# == Schema Information
#
# Table name: competences
#
#  id          :integer          not null, primary key
#  description :text
#  updated_at  :datetime
#  updated_by  :string
#  person_id   :integer
#

class Competence < ApplicationRecord
  belongs_to :person
  validates :person_id, presence: true
  validates_length_of :description, maximum: 1000

  scope :list, -> { order(:id) }
end
