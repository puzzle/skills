class NightlyUpdatePeopleDataPtimeJob < CronJob
  self.cron_expression = '0 0 * * *'

  def perform
    if Skills.use_ptime_sync?
      Ptime::PeopleEmployees.new.update_people_data
    end
  end
end
