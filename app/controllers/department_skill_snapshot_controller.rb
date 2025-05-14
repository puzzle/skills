class DepartmentSkillSnapshotController < CrudController

  def index
    colors = %w[red blue green purple orange]
    color_index = 0

    @data = {
      labels: Date::MONTHNAMES.compact,
      datasets: Skill.all.map do |skill|
        color = colors[color_index]
        color_index = (color_index + 1) % colors.size
        {
          label: skill.title,
          data: Array.new(12) { rand(10) },
          backgroundColor: color,
          borderColor: color,
          fill: false,
          tension: 0.1
        }
      end
    }.to_json

    super
  end
end

