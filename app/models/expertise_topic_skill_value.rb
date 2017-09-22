# encoding: utf-8
#
# == Schema Information
#
# Table name: expertise_topic_skill_values
#
#  id                  :integer          not null, primary key
#  years_of_experience :integer
#  number_of_projects  :integer
#  last_use            :integer
#  skill_level         :string
#  comment             :string
#  person_id           :integer
#  expertise_topic_id  :integer
#

class ExpertiseTopicSkillValue < ApplicationRecord
  belongs_to :expertise_topic
  belongs_to :expertise_category
  belongs_to :person, touch: true

  enum skill_level: [:trainee, :junior, :professional, :senior, :expert]

  validates :skill_level, presence: true
  validates :last_use, length: { is: 4 }, allow_nil: true
  validates :comment, length: { maximum: 500 }, allow_nil: true
  validates :number_of_projects, inclusion: { in: 0..255 }, allow_nil: true
  validates :years_of_experience, inclusion: { in: 0..80 }, allow_nil: true
  validates :expertise_topic_id,
    uniqueness: { scope: :person ,
                  message: '- Etwas ist schief gelaufen. Bitte Seite neu laden' }

  scope :list, -> (person_id = nil, category_id= nil) do
    includes(:expertise_topic).
    includes(expertise_topic: :expertise_category).
    where(person_id: person_id).
    where(expertise_categories: { id: category_id } )
  end
end
