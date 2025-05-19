class DepartmentSkillSnapshotsController < CrudController
  def index
    @data = chart_data.to_json
    super
  end

  private

  def chart_data
    {
      labels: Date::MONTHNAMES.compact,
      datasets: dataset_values.map { |value| build_dataset(value) }
    }
  end

  def dataset_values
    %w[Azubi Junior Senior Professional Expert]
  end

  def build_dataset(value)
    {
      label: value,
      data: Array.new(12) { rand(10) },
      fill: false,
      tension: 0.1
    }
  end
end
