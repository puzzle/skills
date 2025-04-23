module Ptime
  class PeopleEmployees
    include PtimeHelper

    ATTRIBUTES_MAPPING = {
      birthday: :birthdate,
      city: :location,
      email: :email,
      graduation: :title,
      shortname: :shortname
    }.freeze

    EMPLOYED_COMPANY = Company.find_by(name: 'Firma')
    UNEMPLOYED_COMPANY = Company.find_by(name: 'Ex-Mitarbeiter')

    def update_people_data
      fetch_data_of_active_ptime_employees.each do |ptime_employee|
        ActiveRecord::Base.transaction do
          @ptime_employee_attributes = ptime_employee[:attributes]
          @person = Person.find_or_create_by(ptime_employee_id: ptime_employee[:id])
          update_person_data
        end
      end
    end

    def fetch_data_of_active_ptime_employees
      Ptime::Client.new.request(
        :get, 'employees',
        { per_page: MAX_NUMBER_OF_FETCHED_EMPLOYEES }
      ).filter do |ptime_employee|
        ptime_employee.dig(:attributes, :is_employed)
      end
    end

    def update_person_data
      update_mappable_attributes
      update_non_mappable_attributes
      @person.save!
      update_person_roles
    end

    private

    def update_mappable_attributes
      @ptime_employee_attributes.each do |key, value|
        if ATTRIBUTES_MAPPING.key?(key.to_sym)
          @person[ATTRIBUTES_MAPPING[key.to_sym]] =
            value.presence || '-'
        end
      end
    end

    def update_non_mappable_attributes
      is_employed = @ptime_employee_attributes[:is_employed]
      @person.company = is_employed ? EMPLOYED_COMPANY : UNEMPLOYED_COMPANY
      department = Department.find_or_create_by!(name: @ptime_employee_attributes[:department_name])
      @person.department = department
      @person.marital_status = @ptime_employee_attributes[:marital_status].presence || 'single'
      @person.name = employee_full_name(@ptime_employee_attributes)
      @person.nationality, @person.nationality2 = @ptime_employee_attributes[:nationalities]
    end

    def update_person_roles
      PersonRole.where(person_id: @person.id).destroy_all
      @ptime_employee_attributes[:employment_roles].each do |role|
        role_id = Role.find_or_create_by!(name: sanitized_role_name(role[:name])).id
        PersonRole.create!(person_id: @person.id,
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
      PersonRoleLevel.find_by(level: role[:role_level])&.id || PersonRoleLevel.first.id
    end
  end
end
