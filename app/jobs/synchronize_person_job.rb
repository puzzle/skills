require 'net/http'
require 'uri'
require 'json'

class SynchronizePersonJob < CronJob
  queue_as :person_sync

  # Everyday at 02:47
  self.cron_expression = '47 2 * * *'

  def self.perform
    return unless ptime.config_valid?

    people = ptime.people
    updated_people = ptime.updated_people

    PeopleSync::CreateRolesTask.create_roles(people)
    PeopleSync::CreatePeopleTask.create_people(people)
    PeopleSync::MarkExEmployeesTask.mark_ex_employees(people)
    PeopleSync::SyncUpdatedPeopleTask.sync_updated_people(updated_people)
    PeopleSync::SyncPeopleRolesTask.sync_people_roles(people | updated_people)
  end

  private

  def self.ptime
    @ptime ||= PeopleSync::PuzzleTime.new
  end
end
