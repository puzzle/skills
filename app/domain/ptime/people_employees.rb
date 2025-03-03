module Ptime
  class PeopleEmployees
    # TODO: Once PTime API is updated, add 'city: :location & birthdate: :birthdate'
    ATTRIBUTES_MAPPING = {
      firstname: :name,
      shortname: :shortname,
      email: :email,
      marital_status: :marital_status,
      graduation: :title,
      location: :location
    }.freeze

    def find_or_create(ptime_employee_id)
      raise 'No ptime_employee_id provided' unless ptime_employee_id

      person = Person.find_by(ptime_employee_id: ptime_employee_id)
      return person if person

      new_person = Person.new(ptime_employee_id: ptime_employee_id)
      update_person_data(new_person)
    end

    # rubocop:disable Metrics
    def update_person_data(person)
      raise 'Person has no ptime_employee_id' unless person.ptime_employee_id

      begin
        ptime_employee = Ptime::Client.new.request(:get, "employees/#{person.ptime_employee_id}")
      rescue CustomExceptions::PTimeTemporarilyUnavailableError
        return
      end

      ptime_employee[:attributes].each do |key, value|
        if ATTRIBUTES_MAPPING.key?(key.to_sym)
          person[ATTRIBUTES_MAPPING[key.to_sym]] =
            value.presence || '-'
        end
      end

      set_additional_attributes(person, ptime_employee)
      set_full_name(person, ptime_employee)

      person.save!
      person
    end
    # rubocop:enable Metrics

    private

    def set_additional_attributes(person, ptime_employee)
      is_employed = ptime_employee[:attributes][:is_employed]
      person.company = Company.find_by(name: is_employed ? 'Firma' : 'Ex-Mitarbeiter')

      nationalities = ptime_employee[:attributes][:nationalities] || []
      person.nationality = nationalities[0]
      person.nationality2 = nationalities[1]

      # TODO: Remove temporary placeholder values when PTime API got updated
      person.birthdate = DateTime.new(2000, 2, 3)
      person.location = 'Boston, MA'
    end

    def set_full_name(person, ptime_employee)
      first_name = ptime_employee[:attributes][:firstname].presence || ''
      last_name = ptime_employee[:attributes][:lastname].presence || ''
      person[:name] = "#{first_name} #{last_name}".strip
    end
  end
end
