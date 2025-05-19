# This script will assign each person the corresponding employee ID from PuzzleTime
module Ptime
  class AssignEmployeeIds
    include PtimeHelper

    # rubocop:disable Rails/Output
    def run(should_map: false)
      puts 'Notice this is a dry run and mapping will not happen!' unless should_map
      fetch_data

      @ptime_employees_by_provider.each do |provider, provider_employees|
        @provider = provider
        @provider_employees = provider_employees

        puts '-' * 100
        puts "Now mapping with data from PuzzleTime provider #{@provider}"
        map_employees_by_provider(should_map)
        puts '-' * 100
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
        matched_person = Person.where(ptime_employee_id: nil, ptime_data_provider: nil).find_by(email:)

        next record_unmatched_entry(ptime_employee) unless matched_person

        @mapped_people_count += 1
        next unless should_map

        matched_person.update(ptime_employee_id: ptime_employee[:id], ptime_data_provider: @provider)
      end

      print_mapped_and_unmapped_people
    end
    # rubocop:enable Metrics

    def print_mapped_and_unmapped_people
      puts '-' * 80
      puts "#{@mapped_people_count} people were matched successfully for provider #{@provider}"
      puts '-' * 80
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
      @ptime_employees_by_provider =
        ptime_providers.each_with_object({}) do |provider_data, hash|
          ptime_employees = Ptime::Client.new(provider_data)
                                         .request(:get, 'employees', { per_page: MAX_PAGE_SIZE })
          hash[provider_data['COMPANY_IDENTIFIER']] = ptime_employees
        end

      @skills_people = Person.all
      puts 'Successfully fetched data for all providers'
    end
    # rubocop:enable Rails/Output
  end
end
