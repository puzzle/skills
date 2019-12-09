# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :people, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 100 }
  scope :list, -> { order('name asc') }
end
