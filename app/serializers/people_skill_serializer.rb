class PeopleSkillSerializer < ApplicationSerializer
  attributes :id, :person_id, :skill_id, :level, :interest, :certificate, :core_competence

  belongs_to :person, serializer: PersonUpdatedAtSerializer
  belongs_to :skill, serializer: SkillSerializer
end
