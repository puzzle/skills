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
  belongs_to :person

  enum skill_level: [:trainee, :junior, :professional, :senior, :expert]

  validates :years_of_experience, :number_of_projects, :last_use, :skill_level, presence: true
  validates :last_use, length: { is: 4 }
  validates :comment, length: { maximum: 500 }
  validates :number_of_projects, length: { maximum: 5 }
  validates :years_of_experience, inclusion: { in: 0..100 }
  
  scope :list, -> { order(:last_use) }
end
