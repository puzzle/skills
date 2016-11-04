class Person < ApplicationRecord
  has_many :projects
  has_many :activities
  has_many :advanced_trainings
  has_many :educations
  has_many :competences


  def origin_person?
    origin_person_id.blank?
  end

end
