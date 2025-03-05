class Certificate < ApplicationRecord
  validates :name, :points_value, :description,
            :exam_duration, :type_of_exam, :study_time, presence: true

  def to_s
    name
  end
end
