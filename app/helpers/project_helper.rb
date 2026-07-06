module ProjectHelper
  def humanize_project_technologies(project)
    project.project_technologies.map(&:technology).join(', ')
  end
end
