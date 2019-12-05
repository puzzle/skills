# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :people, dependent: :restrict_with_error

  scope :list, -> { order('name asc') }
end
