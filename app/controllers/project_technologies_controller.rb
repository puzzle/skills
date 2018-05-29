class ProjectTechnologiesController < ProjectRelationsController
  self.permitted_attrs = [{ :offer => [] }, :project_id]
end
