class NightlyUpdatePeopleDataPtimeJob < CronJob
  self.cron_expression = '0 3 * * *'

  def perform(**args)
    if Skills.use_ptime_sync?
      Ptime::PeopleEmployees.new.update_people_data(**args)
    end
  end
end
