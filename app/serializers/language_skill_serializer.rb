class LanguageSkillSerializer < ApplicationSerializer
  attributes :id, :language, :level, :certificate

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
