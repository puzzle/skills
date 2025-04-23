# This script will assign each person the corresponding employee ID from PuzzleTime
module Ptime
  class AssignEmployeeIds
    include PtimeHelper

    MAX_NUMBER_OF_FETCHED_EMPLOYEES = 1000

    # rubocop:disable Rails/Output
    def run(should_map: false)
      puts 'Notice this is a dry run and mapping will not happen!' unless should_map
      fetch_data

      puts "Currently there are:
      - #{@ptime_employees.length} employees in PuzzleTime
      - #{@skills_people.count} people in PuzzleSkills
      This is a difference of #{(@skills_people.count - @ptime_employees.length).abs} entries"
      map_employees(should_map)
    end

    private

    # rubocop:disable Metrics
    def map_employees(should_map)
      puts 'Assigning employee IDs now...' if should_map

      unmatched_entries = []
      mapped_people_count = 0

      @ptime_employees.each do |ptime_employee|
        ptime_employee_email = ptime_employee[:attributes][:email]
        matched_person = Person.where(ptime_employee_id: nil).find_by(email: ptime_employee_email)

        if matched_person.nil?
          unmatched_entries << {
            name: employee_full_name(ptime_employee[:attributes]), id: ptime_employee[:id]
          }
        else
          if should_map
            matched_person.ptime_employee_id = ptime_employee[:id]
            matched_person.save!
          end
          mapped_people_count += 1
        end
      end

      puts '--------------------------'
      puts "#{mapped_people_count} people were matched successfully"
      puts '--------------------------'
      puts "#{unmatched_entries.size} people didn't match"
      unmatched_entries.each { |entry| puts "- #{entry[:name]} with id #{entry[:id]}" }
    end
    # rubocop:enable Metrics

    def fetch_data
      puts 'Fetching required data...'
      @ptime_employees = Ptime::Client.new.request(:get, 'employees',
                                                   { per_page: MAX_NUMBER_OF_FETCHED_EMPLOYEES })
      @skills_people = Person.all
      puts 'Successfully fetched data'
    end
    # rubocop:enable Rails/Output
  end
end
