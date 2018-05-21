class PersonCompetenceSerializer < ApplicationSerializer
  attributes :id, :category, :offer
  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
