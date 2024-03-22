# frozen_string_literal: true

# == Schema Information
#
# Table name: people_skills
#
#  id              :bigint(8)        not null, primary key
#  person_id       :bigint(8)
#  skill_id        :bigint(8)
#  level           :integer
#  interest        :integer
#  certificate     :boolean          default(FALSE)
#  core_competence :boolean          default(FALSE)
#

class PeopleSkill < ApplicationRecord
  belongs_to :person
  belongs_to :skill

  validates :certificate, :core_competence, exclusion: { in: [nil],
                                                         message: 'muss ausgefüllt werden' }

  validates :level, :interest, presence: { message: 'ist nicht ausgefüllt' }

  validates :level, :interest, numericality: { only_integer: true,
                                               greater_than_or_equal_to: 0,
                                               less_than_or_equal_to: 5,
                                               allow_nil: true }

  validates :person_id, uniqueness: { scope: :skill_id,
                                      message: 'Pro Person kann ein Skill nicht ' \
                                               'mehrmals ausgewählt werden' }

  scope :list, -> { order(:person_id, :skill_id) }
  scope :core_competence, -> { where('core_competence = true')}
end
