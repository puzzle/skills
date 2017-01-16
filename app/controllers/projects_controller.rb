class ProjectsController < PersonRelationsController
  self.permitted_attrs = [:description, :title, :role, :technology, :year_to, :year_from]
end
