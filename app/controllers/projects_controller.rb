class ProjectsController < PersonRelationsController
  self.permitted_attrs = %i[description title role technology
                            start_at finish_at person_id]

  self.nested_models = %i[project_technologies]
end
