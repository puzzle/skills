class NightlyUpdatePeopleDataPtimeJob < CronJob
  self.cron_expression = '0 0 * * *'

  def perform
    Ptime::PeopleEmployees.new.update_people_data
  end
end
