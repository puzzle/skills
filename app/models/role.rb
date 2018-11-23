class Role < ApplicationRecord
  has_and_belongs_to_many :people, dependent: :restrict
  validates :name, length: {maximum: 100}

  scope :list, -> { order(:name) }
end
