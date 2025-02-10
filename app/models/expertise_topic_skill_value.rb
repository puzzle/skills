# frozen_string_literal: true

#
# == Schema Information
#
# Table name: expertise_topic_skill_values
#
#  id                  :bigint(8)        not null, primary key
#  years_of_experience :integer
#  number_of_projects  :integer
#  last_use            :integer
#  skill_level         :integer
#  comment             :string
#  person_id           :bigint(8)        not null
#  expertise_topic_id  :bigint(8)        not null
#

class ExpertiseTopicSkillValue < ApplicationRecord
  belongs_to :expertise_topic
  belongs_to :person, touch: true

  enum :skill_level,
       { unweighted: -1, trainee: 0, junior: 1, professional: 2, senior: 3, expert: 4 }

  validates :skill_level, presence: true, inclusion: { in: skill_levels.keys }
  validates :last_use, length: { is: 4 }, allow_nil: true
  validates :comment, length: { maximum: 500 }, allow_nil: true
  validates :number_of_projects, inclusion: { in: 0..255 }, allow_nil: true
  validates :years_of_experience, inclusion: { in: 0..80 }, allow_nil: true
  validates :expertise_topic_id,
            uniqueness: { scope: :person,
                          message: '- Etwas ist schief gelaufen. Bitte Seite neu laden' }

  scope :list, lambda { |person_id = nil, category_id = nil|
    includes(:expertise_topic).
      includes(expertise_topic: :expertise_category).
      where(person_id: person_id).
      where(expertise_categories: { id: category_id })
  }
end
