# frozen_string_literal: true

class UpdatePeopleData
  module Ptime
    ATTRIBUTE_MAPPING = { shortname: :shortname, email: :email, marital_status: :marital_status,
                          graduation: :title }.freeze

    # rubocop:disable Metrics
    def run
      ptime_employees = Ptime::Client.new.get('employees', { per_page: 1000 })['data']
      ptime_employees.each do |ptime_employee|
        ptime_employee_firstname = ptime_employee['attributes']['firstname']
        ptime_employee_lastname = ptime_employee['attributes']['lastname']
        ptime_employee_name = "#{ptime_employee_firstname} #{ptime_employee_lastname}"

        skills_person = Person.find_by(ptime_employee_id: ptime_employee['id'])
        skills_person ||= Person.new

        skills_person[:name] = ptime_employee_name
        ptime_employee['attributes'].each do |key, value|
          skills_person[ATTRIBUTE_MAPPING[key]] = value
        end
        skills_person.save!
      end
    end
    # rubocop:enable Metrics
  end
end
