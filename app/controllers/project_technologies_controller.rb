# frozen_string_literal: true

class ProjectTechnologiesController < ProjectRelationsController
  self.permitted_attrs = [{ offer: [] }, :project_id]
end
