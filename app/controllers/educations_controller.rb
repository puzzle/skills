class EducationsController < PersonRelationsController
  self.permitted_attrs = [:location, :title, :year_from, :year_to]
end
