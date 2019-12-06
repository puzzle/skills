# frozen_string_literal: true

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
  belongs_to :people_role_level

  validates :person_id, :role_id, presence: true

  validate :percent_must_be_a_number

  scope :list, -> { order(:person_id, :role_id) }

  private

  def percent_must_be_a_number
    return if percent.nil? || percent.between?(0, 200)
    errors.add(:percent, 'muss zwischen 0 und 200 sein')
  end
end
