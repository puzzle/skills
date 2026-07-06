module ProjectHelper
  def humanize_project_technologies(project)
    ([project.technology] + project.skills.map(&:title)).compact_blank.join(', ')
  end
end
