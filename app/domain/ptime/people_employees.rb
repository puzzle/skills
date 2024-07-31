module Ptime
  class PeopleEmployees
    ATTRIBUTES_MAPPING = { full_name: :name, shortname: :shortname, email: :email, marital_status:
      :marital_status, graduation: :title, birthdate: :birthdate,
                           location: :location }.freeze
    def find_or_create(ptime_employee_id)
      raise 'No ptime_employee_id provided' unless ptime_employee_id

      person = Person.find_by(ptime_employee_id: ptime_employee_id)
      return person unless person.nil?

      new_person = Person.new(ptime_employee_id: ptime_employee_id)

      update_person_data(new_person)
    end

    # rubocop:disable Metrics
    def update_person_data(person)
      raise 'Person has no ptime_employee_id' unless person.ptime_employee_id

      ptime_employee = Ptime::Client.new.request(:get, "employees/#{person.ptime_employee_id}")
    rescue CustomExceptions::PTimeTemporarilyUnavailableError
      return
    else
      ptime_employee[:attributes].each do |key, value|
        if key.to_sym.in?(ATTRIBUTES_MAPPING.keys)
          person[ATTRIBUTES_MAPPING[key.to_sym]] = (value.presence || '-')
        end
      end
      set_additional_attributes(person, ptime_employee)
      person.save!
      person
    end
    # rubocop:enable Metrics

    def set_additional_attributes(person, ptime_employee)
      ptime_employee_employed = ptime_employee[:attributes][:is_employed]
      person.company = Company.find_by(name: ptime_employee_employed ? 'Firma' : 'Ex-Mitarbeiter')
      ptime_employee_nationalities = ptime_employee[:attributes][:nationalities]
      person.nationality = ptime_employee_nationalities[0]
      person.nationality2 = ptime_employee_nationalities[1]
    end
  end
end
