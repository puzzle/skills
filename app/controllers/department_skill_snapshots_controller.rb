# frozen_string_literal: true

include DateHelper

class DepartmentSkillSnapshotsController < CrudController
  def index
    @data = chart_data.to_json
    super
  end

  private

  def chart_data
    {
      labels: months,
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

  def months
    return [] if active_snapshots.empty?

    (first_month_with_data..last_month_with_data).map do |month_number|
      Date::MONTHNAMES[month_number]
    end
  end

  def get_data_for_each_level(level)
    skill_id = params[:skill_id].to_s

    (first_month_with_data..last_month_with_data).map do |month_number|
      snapshot = active_snapshots[month_number]

      if snapshot
        levels = snapshot.department_skill_levels[skill_id] || []
        levels.count(level)
      end
    end
  end

  def first_month_with_data
    @first_month_with_data ||= active_snapshots.keys.min
  end

  def last_month_with_data
    @last_month_with_data ||= active_snapshots.keys.max
  end

  def active_snapshots
    @active_snapshots ||= begin
      year = params[:year].to_i
      start_date = Date.new(year, 1, 1)
      end_date = start_date.end_of_year

      snapshots_of_this_year(start_date, end_date).index_by do |snapshot|
        snapshot.created_at.month
      end
    end
  end

  def snapshots_of_this_year(start_date, end_date)
    DepartmentSkillSnapshot.where(
      department_id: params[:department_id],
      created_at: start_date..end_date
    )
  end
end
