module Ptime
  class UpdatePersonData
    def create_person(ptime_employee_id)
      raise 'No ptime_employee_id provided' unless ptime_employee_id

      person = Person.find_by(ptime_employee_id: ptime_employee_id)
      return person unless person.nil?

      update_person_data(Person.new(ptime_employee_id: ptime_employee_id))
    end

    # rubocop:disable Metrics
    def update_person_data(person)
      attribute_mapping = { full_name: :name, shortname: :shortname, email: :email, marital_status:
                            :marital_status, graduation: :title, birthdate: :birthdate,
                            location: :location }.freeze

      begin
        raise 'Person has no ptime_employee_id' unless person.ptime_employee_id

        ptime_employee = Ptime::Client.new.get("employees/#{person.ptime_employee_id}")['data']
      rescue RestClient::NotFound
        raise "Ptime_employee with ptime_employee_id #{person.ptime_employee_id} not found"
      else
        ptime_employee['attributes'].each do |key, value|
          if key.to_sym.in?(attribute_mapping.keys)
            person[attribute_mapping[key.to_sym]] = (value.presence || '-')
          end
        end
        ptime_employee_employed = ptime_employee['attributes']['is_employed']
        person.company = Company.find_by(name: ptime_employee_employed ? 'Firma' : 'Ex-Mitarbeiter')
        ptime_employee_nationalities = ptime_employee['attributes']['nationalities']
        person.nationality = ptime_employee_nationalities[0]
        person.nationality2 = ptime_employee_nationalities[1]
        person.save!
        person
      end
    end
    # rubocop:enable Metrics
  end
end
