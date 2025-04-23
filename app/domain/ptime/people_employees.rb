module Ptime
  class PeopleEmployees
    ATTRIBUTES_MAPPING = {
      shortname: :shortname,
      email: :email,
      marital_status: :marital_status,
      graduation: :title,
      city: :location,
      birthday: :birthdate
    }.freeze

    def update_people_data
      fetch_data
      @ptime_employees.each do |ptime_employee|
        ActiveRecord::Base.transaction do
          person = find_or_create(ptime_employee.id)
          update_person_data(person, ptime_employee[:attributes])
        end
      end
    end

    def fetch_data
      @ptime_employees = Ptime::Client.new.request(:get, 'employees',
                                                   { per_page: MAX_NUMBER_OF_FETCHED_EMPLOYEES })
    end

    def find_or_create(ptime_employee_id)
      raise 'No ptime_employee_id provided' unless ptime_employee_id

      person = Person.find_by(ptime_employee_id: ptime_employee_id)
      person || Person.new(ptime_employee_id: ptime_employee_id)
    end

    # rubocop:disable Metrics
    def update_person_data(person, ptime_employee_attributes)
      raise 'Person has no ptime_employee_id' unless person.ptime_employee_id

      ptime_employee_attributes.each do |key, value|
        if ATTRIBUTES_MAPPING.key?(key.to_sym)
          person[ATTRIBUTES_MAPPING[key.to_sym]] =
            value.presence || '-'
        end
      end

      set_additional_attributes(person, ptime_employee_attributes)
      set_person_roles(person, ptime_employee_attributes)
      person.save!

      person
    end
    # rubocop:enable Metrics

    private

    def set_additional_attributes(person, ptime_employee_attributes)
      is_employed = ptime_employee_attributes[:is_employed]
      person.company = Company.find_by(name: is_employed ? 'Firma' : 'Ex-Mitarbeiter')

      nationalities = ptime_employee_attributes[:nationalities] || []
      person.nationality = nationalities[0]
      person.nationality2 = nationalities[1]
      person.name = employee_full_name(ptime_employee_attributes)
    end

    def set_person_roles(person, ptime_employee_attributes)
      PersonRole.where(person_id: person.id).destroy_all

      ptime_employee_attributes[:employment_roles].each do |role|
        role_id = Role.find_or_create_by(name: sanitized_role_name(role[:name])).id
        PersonRole.create!(person_id: person.id,
                           role_id: role_id,
                           percent: role[:percent],
                           person_role_level_id: person_role_level_id_by_role(role))
      end
    end

    # Remove prefix of role such as 'T1' or 'M2' which is not needed
    def sanitized_role_name(role_name)
      role_name.gsub(/\A[A-Z]\d+\s/, '')
    end

    def person_role_level_id_by_role(role)
      PersonRoleLevel.find_by(level: role[:role_level]).id || PersonRoleLevel.first.id
    end
  end
end
