class Role < ApplicationRecord
  has_and_belongs_to_many :people, dependent: :restrict

  scope :list, -> { order(:name) }
end
