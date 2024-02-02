# frozen_string_literal: true

class Api::ProjectTechnologiesController < Api::ProjectRelationsController
  self.permitted_attrs = [{ offer: [] }, :project_id]
end
