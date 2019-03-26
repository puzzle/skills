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
  validates :certificate, :core_competence, exclusion: { in: [nil] }
  validates :level, :interest, numericality: { only_integer: true,
                                               greater_than_or_equal_to: 0,
                                               allow_nil: true,
                                               less_than_or_equal_to: 5 }

  scope :list, -> { order(:person_id, :skill_id) }
end
