class CompetencesController < PersonRelationsController
  self.permitted_attrs = [:description]
end
