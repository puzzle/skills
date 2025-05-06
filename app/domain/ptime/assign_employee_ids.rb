# This script will assign each person the corresponding employee ID from PuzzleTime
module Ptime
  class AssignEmployeeIds
    include PtimeHelper

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

      @unmatched_entries = []
      mapped_people_count = 0

      @ptime_employees.each do |ptime_employee|
        email = ptime_employee[:attributes][:email]
        matched_person = Person.where(ptime_employee_id: nil).find_by(email:)

        next record_unmatched_entry(ptime_employee) unless matched_person

        @mapped_people_count += 1
        next unless should_map

        matched_person.update(ptime_employee_id: ptime_employee[:id])
      end

      puts '--------------------------'
      puts "#{mapped_people_count} people were matched successfully"
      puts '--------------------------'
      puts "#{@unmatched_entries.size} people didn't match"
      @unmatched_entries.each { |entry| puts "- #{entry[:name]} with id #{entry[:id]}" }
    end
    # rubocop:enable Metrics

    def record_unmatched_entry(ptime_employee)
      @unmatched_entries << {
        id: ptime_employee[:id],
        name: employee_full_name(ptime_employee[:attributes]),
      }
    end

    def fetch_data
      puts 'Fetching required data...'
      @ptime_employees = Ptime::Client.new.request(:get, 'employees',
                                                   { per_page: MAX_PAGE_SIZE })
      @skills_people = Person.all
      puts 'Successfully fetched data'
    end
    # rubocop:enable Rails/Output
  end
end
