module Ptime
  class PeopleEmployees
    ATTRIBUTES_MAPPING = {
      firstname: :name,
      shortname: :shortname,
      email: :email,
      marital_status: :marital_status,
      graduation: :title,
      city: :location,
      birthday: :birthdate
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

      person.save!
      set_person_roles(person, ptime_employee)
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
      person.name = split_name(ptime_employee[:attributes][:full_name])
    end

    def split_name(full_name)
      parts = full_name.split
      last_names = parts[0..-2].join(' ')
      first_name = parts[-1]

      "#{first_name} #{last_names}"
    end

    def set_person_roles(person, ptime_employee)
      ptime_employee[:attributes][:employment_roles].each do |role|
        role_id = find_or_create_role(role[:name])
        # next if person.person_roles.exists?(role_id: role_id)

        PersonRole.create!(person_id: person.id,
                           role_id: role_id,
                           percent: role[:percent],
                           person_role_level_id: 1)
      end
    end

    def find_or_create_role(role_name)
      Role.find_by(name: role_name)&.id || Role.create!(name: sanitized_role_name(role_name)).id
    end

    def sanitized_role_name(role_name)
      role_name.gsub(/\A[A-Z]\d+\s/, '')
    end
  end
end
