class Certificate < ApplicationRecord
  validates :title, :points_value, presence: true

  validates :designation, :title, :provider, :comment, :type_of_exam, length: { maximum: 250 }

  default_scope { order(:title) }

  def to_s
    title
  end
end
