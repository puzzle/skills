class Certificate < ApplicationRecord
  validates :name, :points_value, :description,
            :exam_duration, :type_of_exam, :study_time, presence: true

  validates :name, :provider, length: { maximum: 100 }
  validates :description, :notes, length: { maximum: 250 }

  def to_s
    name
  end
end
