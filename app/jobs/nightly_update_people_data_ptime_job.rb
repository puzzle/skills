class NightlyUpdatePeopleDataPtimeJob < CronJob
  self.cron_expression = '* * * * *'

  def perform
    if Skills.use_ptime_sync?
      Ptime::PeopleEmployees.new.update_people_data
    end
  end
end
