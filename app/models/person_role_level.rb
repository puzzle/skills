# frozen_string_literal: true

class PersonRoleLevel < ApplicationRecord
  has_many :person_roles, dependent: :restrict_with_error

  scope :list, -> { order('level asc') }
end
