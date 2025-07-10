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
  accepts_nested_attributes_for :skill

  before_create :before_actions
  after_create :update_associations_updated_at
  before_update :before_actions

  after_update :update_associations_updated_at
  after_destroy :update_associations_updated_at

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
  scope :core_competence, -> { where('core_competence = true') }

  def skill_attributes=(attributes)
    if Skill.exists?(attributes[:id])
      self.skill = Skill.find(attributes[:id])
    else
      attributes.delete(:id)
    end
    super
  end

  def before_actions
    self.level = 1 if level.zero? && !unrated
    self.interest = 1 if interest.zero? && !unrated

    if unrated
      unrate
    end
  end

  def unrate
    self.level = 0
    self.interest = 0
    self.certificate = false
    self.core_competence = false
  end

  def to_s
    skill&.title
  end

  def update_associations_updated_at
    timestamp = Time.zone.now
    person.update!(associations_updated_at: timestamp)
  end
end
