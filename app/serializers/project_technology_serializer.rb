class ProjectTechnologySerializer < ApplicationSerializer
  attributes :id, :offer
  belongs_to :project, serializer: ProjectInProjectTechnologySerializer
end
