# This script will assign each person the corresponding employee ID from PuzzleTime
module Ptime
  class AssignEmployeeIds
    include PtimeHelper

    SHORT_OUTPUT_SEPARATOR = '-' * 80
    LONG_OUTPUT_SEPARATOR = '-' * 100

    # rubocop:disable Rails/Output
    def run(should_map: false)
      puts 'Notice this is a dry run and mapping will not happen!' unless should_map
      fetch_data

      @ptime_employees_by_provider.each do |provider, provider_employees|
        @provider = provider
        @provider_employees = provider_employees

        puts LONG_OUTPUT_SEPARATOR
        puts "Now mapping with data from PuzzleTime provider #{@provider}"
        map_employees_by_provider(should_map)
        puts LONG_OUTPUT_SEPARATOR
      end
    end

    private

    def map_employees_by_provider(should_map)
      puts "Currently there are:
      - #{@provider_employees.length} employees coming from provider #{@provider}
      - #{@skills_people.count} people in PuzzleSkills
      This is a difference of #{(@skills_people.count - @provider_employees.length).abs} entries"
      map_employees(should_map)
    end

    # rubocop:disable Metrics
    def map_employees(should_map)
      puts "Assigning employee IDs for people from provider #{@provider} now..." if should_map

      @unmatched_entries = []
      @mapped_people_count = 0

      @provider_employees.each do |ptime_employee|
        email = ptime_employee[:attributes][:email]
        matched_person = Person.where(ptime_employee_id: nil, ptime_data_provider: nil)
                               .find_by(email:)

        is_employed = ptime_employee[:attributes][:has_relevant_employment]
        next record_unmatched_entry(ptime_employee) unless matched_person && is_employed

        @mapped_people_count += 1
        next unless should_map

        matched_person.update!(ptime_employee_id: ptime_employee[:id],
                               ptime_data_provider: @provider)
      end

      print_mapped_and_unmapped_people
    end
    # rubocop:enable Metrics

    def print_mapped_and_unmapped_people
      puts SHORT_OUTPUT_SEPARATOR
      puts "#{@mapped_people_count} people were matched successfully for provider #{@provider}"
      puts SHORT_OUTPUT_SEPARATOR
      puts "#{@unmatched_entries.size} people didn't match for provider #{@provider}"
      @unmatched_entries.each { |entry| puts "- #{entry[:name]} with id #{entry[:id]}" }
    end

    def record_unmatched_entry(ptime_employee)
      @unmatched_entries << {
        id: ptime_employee[:id],
        name: employee_full_name(ptime_employee[:attributes])
      }
    end

    def fetch_data
      puts 'Fetching required data from all providers...'
      @ptime_employees_by_provider = fetch_data_of_ptime_employees_by_provider
      @skills_people = Person.all
      puts 'Successfully fetched data for all providers'
    end
    # rubocop:enable Rails/Output
  end
end
