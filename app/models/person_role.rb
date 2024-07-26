# frozen_string_literal: true

# == Schema Information
#
# Table name: person_roles
#
#  id                       :bigint(8)        not null, primary key
#  person_id                :bigint(8)
#  role_id                  :bigint(8)
#  person_role_level_id     :integer
#  percent                  :decimal(5, 2)
#

class PersonRole < ApplicationRecord
  belongs_to :person
  belongs_to :role
  belongs_to :person_role_level


  validate :percent_must_be_a_number

  scope :list, -> { order(:person_id, :role_id) }

  private

  def percent_must_be_a_number
    return if percent.nil? || percent.between?(0, 200)

    errors.add(:percent, :valid_percent_range)
  end
end
