class Certificate < ApplicationRecord
  validates :name, :points_value, presence: true

  validates :name, :provider, :type_of_exam, :description, :notes, length: { maximum: 250 }

  default_scope { order(:name) }

  def to_s
    name
  end
end
