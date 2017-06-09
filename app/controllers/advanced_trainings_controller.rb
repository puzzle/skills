# encoding: utf-8

class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = [:description, :year_from, :year_to, :person_id]
end
