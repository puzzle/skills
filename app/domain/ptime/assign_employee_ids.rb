# This script will assign each person the corresponding employee ID from PuzzleTime
module Ptime
  class AssignEmployeeIds

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

      ambiguous_entries = []
      unmatched_entries = []
      mapped_people_count = 0

      @ptime_employees.each do |ptime_employee|
        ptime_employee_firstname = ptime_employee[:attributes][:firstname]
        ptime_employee_lastname = ptime_employee[:attributes][:lastname]
        ptime_employee_name = "#{ptime_employee_firstname} #{ptime_employee_lastname}"
        ptime_employee_email = ptime_employee[:attributes][:email]
        matched_skills_people = Person.where(ptime_employee_id: nil)
                                      .where(name: ptime_employee_name)
                                      .where(email: ptime_employee_email)

        if matched_skills_people.empty?
          unmatched_entries << { name: ptime_employee_name, id: ptime_employee[:id] }
        elsif matched_skills_people.one?
          if should_map
            matched_skills_person = matched_skills_people.first
            matched_skills_person.ptime_employee_id = ptime_employee[:id]
            matched_skills_person.save!
          end
          mapped_people_count += 1
        else
          ambiguous_entries << { name: ptime_employee_name, id: ptime_employee[:id] }
        end
      end

      puts '--------------------------'
      puts "#{mapped_people_count} people were matched successfully"
      puts '--------------------------'
      puts "#{unmatched_entries.size} people didn't match"
      unmatched_entries.each { |entry| puts "- #{entry[:name]} with id #{entry[:id]}" }
      puts '--------------------------'
      puts "#{ambiguous_entries.size} people ambiguous matched"
      ambiguous_entries.each { |entry| puts "- #{entry[:name]} with id #{entry[:id]}" }
    end
    # rubocop:enable Metrics

    def fetch_data
      puts 'Fetching required data...'
      @ptime_employees = Ptime::Client.new.request(:get, 'employees', { per_page: 1000 })[:data]
      @skills_people = Person.all
      puts 'Successfully fetched data'
    end
    # rubocop:enable Rails/Output
  end
end
