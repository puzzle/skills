include DateHelper

class DepartmentSkillSnapshotsController < CrudController
  def index
    @data = chart_data.to_json
    super
  end

  private

  def chart_data
    {
      labels: months.compact,
      datasets: dataset_values.map.with_index(1) do |label, level|
        build_dataset(label, level)
      end.compact
    }
  end

  def dataset_values
    %w[Azubi Junior Senior Professional Expert]
  end

  # level corresponds to 1-5 (Azubi = 1, ..., Expert = 5)
  def build_dataset(label, level)
    return unless params[:department_id].present? &&
      params[:skill_id].present? &&
      params[:year].present?

    {
      label: label,
      data: get_data_for_each_level(level),
      fill: false,
      tension: 0.1
    }
  end

  def get_data_for_each_level(level)
    monthly_data = Array.new(12, 0)
    skill_id = params[:skill_id].to_s

    find_snapshots_by_department_id_and_year.each do |snapshot|
      month_index = snapshot.created_at.month - 1
      levels = snapshot.department_skill_levels[skill_id] || []
      monthly_data[month_index] += levels.count(level)
    end

    monthly_data
  end

  def find_snapshots_by_department_id_and_year
    year = params[:year].to_i
    start_date = Date.new(year, 1, 1)
    end_date = start_date.end_of_year

    DepartmentSkillSnapshot.where(
      department_id: params[:department_id],
      created_at: start_date..end_date
    )
  end
end
