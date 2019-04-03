class ProjectsController < PersonRelationsController
  self.permitted_attrs = %i[description title role technology
                            month_from year_from month_to year_to person_id]

  self.nested_models = %i[project_technologies]
end
