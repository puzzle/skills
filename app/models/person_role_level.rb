# frozen_string_literal: true

class PersonRoleLevel < ApplicationRecord
  has_many :person_roles, dependent: :restrict_with_error

  validates :level, presence: true
  scope :list, -> { order(:level) }
end
