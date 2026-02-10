# frozen_string_literal: true

class Department < ApplicationRecord
  include Discard::Model

  has_many :people, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 100 }
  scope :list, -> { order(:name) }

  default_scope { kept }

  def destroy
    discard
  end

  def to_s
    name
  end
end
