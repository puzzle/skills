# == Schema Information
#
# Table name: people_roles
#
#  id        :bigint(8)        not null, primary key
#  person_id :bigint(8)
#  role_id   :bigint(8)
#  level     :string
#  percent   :decimal(5, 2)
#

class PeopleRole < ApplicationRecord
  belongs_to :person
  belongs_to :role

  validates :person_id, :role_id, :level, presence: true

  validate :percent_must_be_a_number

  scope :list, -> { order(:person_id, :role_id) }

  private

  def percent_must_be_a_number
    return errors.add(:percent, 'muss ausgefüllt werden') if percent.nil?
    return if percent.between?(0, 200) 
    errors.add(:percent, 'muss zwischen 0 und 200 sein')
  end
end
