# frozen_string_literal: true

class PeopleRoleLevel < ApplicationRecord
  has_many :people_roles, dependent: :restrict_with_error

  scope :list, -> { order('name asc') }
end
