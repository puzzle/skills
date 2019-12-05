# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :people

  scope :list, -> { order('name asc') }
end
