class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = [:description, :year_from, :year_to]
end
