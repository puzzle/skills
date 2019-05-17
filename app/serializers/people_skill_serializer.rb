class PeopleSkillSerializer < ApplicationSerializer
  attributes :id, :person_id, :skill_id, :level, :interest, :certificate, :core_competence

  belongs_to :person, serializer: PersonMinimalSerializer
  belongs_to :skill, serializer: SkillSerializer
end
