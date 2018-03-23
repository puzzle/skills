class AdvancedTrainingSerializer < ApplicationSerializer
  attributes :id, :description, :updated_by, :year_from, :year_to

  belongs_to :person, serializer: PersonUpdatedAtSerializer
end
