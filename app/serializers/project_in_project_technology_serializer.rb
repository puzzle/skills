# frozen_string_literal: true

class ProjectInProjectTechnologySerializer < ApplicationSerializer
  type :project

  attributes :id, :title
end
