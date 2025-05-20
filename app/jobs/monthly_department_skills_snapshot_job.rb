class MonthlyDepartmentSkillsSnapshotJob < CronJob
  # Perform job on first day of month at 3am
  self.cron_expression = '0 3 1 * *'

  def perform
    DepartmentSkillsSnapshotBuilder.new.snapshot_all_departments
  end
end
