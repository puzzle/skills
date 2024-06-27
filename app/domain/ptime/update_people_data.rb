# frozen_string_literal: true

class UpdatePeopleData
  module Ptime
    ATTRIBUTES = []
    def run
      ptime_employees = Ptime::Client.new.get('employees', { per_page: 1000 })['data']
      person_ptime_ids = Person.pluck(:ptime_employee_id)
      ptime_employees.each do |ptime_employee|
        if ptime_employee['id'].in?(person_ptime_ids)
          person = Person.where(ptime_employee_id: ptime_employee['id'])
        end
      end
    end
  end
end
