# frozen_string_literal: true

module Ptime
  class UpdatePeopleData
    ATTRIBUTE_MAPPING = { shortname: :shortname, email: :email, marital_status: :marital_status,
                          graduation: :title }.freeze

    # rubocop:disable Metrics
    def run
      ptime_employees = Ptime::Client.new.request(:get, 'employees', { per_page: 1000 })
      ptime_employees.each do |ptime_employee|
        ptime_employee_firstname = ptime_employee[:attributes][:firstname]
        ptime_employee_lastname = ptime_employee[:attributes][:lastname]
        ptime_employee_name = "#{ptime_employee_firstname} #{ptime_employee_lastname}"

        skills_person = Person.find_by(ptime_employee_id: ptime_employee[:id])
        skills_person ||= Person.new

        skills_person.name = ptime_employee_name
        skills_person.ptime_employee_id ||= ptime_employee[:id]
        ptime_employee[:attributes].each do |key, value|
          if key.to_sym.in?(ATTRIBUTE_MAPPING.keys)
            skills_person[ATTRIBUTE_MAPPING[key.to_sym]] = value
          end
        end
        skills_person.company = Company.first
        skills_person.birthdate = '1.1.2000'
        skills_person.location = 'Bern'
        skills_person.nationality = 'CH'
        skills_person.save!
      end
    end
    # rubocop:enable Metrics
  end
end
