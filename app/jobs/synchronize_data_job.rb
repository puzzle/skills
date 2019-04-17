require 'net/http'
require 'uri'
require 'json'

class SynchronizeDataJob < CronJob
  queue_as :sync_data

  # Everyday at 02:47
  # self.cron_expression = '47 2 * * *'

  # Every minute
  self.cron_expression = '* * * * *'

  def perform
    return unless ptime.config_valid?

    people = ptime.people
    updated_people = ptime.updated_people

    PuzzleTime::CreateRolesTask.create_roles(people)
    PuzzleTime::CreatePeopleTask.create_people(people)
    PuzzleTime::MarkExEmployeesTask.mark_ex_employees(people)
    PuzzleTime::SynchronizeUpdatedPeopleTask.synchronize_updated_people(updated_people)
    PuzzleTime::CreatePeopleRolesTask.create_people_roles(people | updated_people)
  end

  private

  def ptime
    @ptime ||= PuzzleTime.new
  end
end
