class DepartmentSkillSnapshotsController < CrudController
  def index
    @data = chart_data.to_json
    super
  end

  private

  def chart_data
    {
      labels: Date::MONTHNAMES.compact,
      datasets: dataset_values.map.with_index(1) { |label, level| build_dataset(label, level) }.compact
    }
  end

  def dataset_values
    %w[Azubi Junior Senior Professional Expert]
  end

  # level corresponds to 1-5 (Azubi = 1, ..., Expert = 5)
  def build_dataset(label, level)
    return unless params[:department_id].present? && params[:skill_id].present? && params[:year].present?

    {
      label: label,
      data: get_data_for_level(level),
      fill: false,
      tension: 0.1
    }
  end

  def get_data_for_level(level)
    monthly_data = Array.new(12, 0)
    skill_id = params[:skill_id].to_s

    snapshots = DepartmentSkillSnapshot.where(
      department_id: params[:department_id]
    )

    snapshots.each do |snapshot|
      month_index = snapshot.created_at.month - 1
      levels = snapshot.department_skill_levels[skill_id] || []
      monthly_data[month_index] += levels.count(level)
    end

    monthly_data
  end
end
