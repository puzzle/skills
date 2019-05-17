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

class PeopleSkillSerializer < ApplicationSerializer
  attributes :id, :person_id, :skill_id, :level, :interest, :certificate, :core_competence

  belongs_to :person, serializer: PersonMinimalSerializer
  belongs_to :skill, serializer: SkillSerializer
end
