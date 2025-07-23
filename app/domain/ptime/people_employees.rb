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

    def initialize
      @unemployed_company = Company.find_by(name: 'Ex-Mitarbeiter')
    end

    def update_people_data(is_manual_sync: false)
      @update_failed_names = {}
      update_all_people
      if @update_failed_names.values.flatten.any? && !is_manual_sync
        raise PtimeExceptions::PersonUpdateWithPtimeDataFailed,
              I18n.t('admin.manual_ptime_sync.manual_sync.failed_people_updates',
                     names: update_failed_names_message(@update_failed_names, :en), locale: :en)
      end
      @update_failed_names
    end

    private

    def update_all_people
      fetch_data_of_ptime_employees_by_provider.each do |provider, provider_employees|
        active_employees, inactive_employees = provider_employees.partition do |ptime_employee|
          ptime_employee.dig(:attributes, :has_relevant_employment)
        end
        @provider = provider
        @update_failed_names[provider] = []
        @employed_company = Company.find_by(name: provider)
        update_active_people(active_employees)
        update_inactive_people(inactive_employees)
      end
    end

    def update_active_people(employees)
      employees.each do |employee|
        ActiveRecord::Base.transaction do
          @ptime_employee_attributes = employee[:attributes]
          @person = Person.find_or_create_by(ptime_employee_id: employee[:id],
                                             ptime_data_provider: @provider)
          update_person_data
        rescue ActiveRecord::RecordInvalid
          @update_failed_names[@provider].push(@person.name)
        end
      end
    end

    def update_inactive_people(employees)
      employees.each do |employee|
        person = Person.find_by(ptime_employee_id: employee[:id], ptime_data_provider: @provider)
        person&.company = @unemployed_company
        # Save without updating updated_at so we can show when a person was last updated by the sync
        person&.save!(touch: false)
      rescue ActiveRecord::RecordInvalid
        @update_failed_names[@provider].push(person&.name)
      end
    end

    def update_person_data
      update_directly_mappable_attributes
      update_indirectly_mappable_attributes
      @person.save!
      update_person_roles
    end

    def update_directly_mappable_attributes
      @ptime_employee_attributes.each do |key, value|
        next unless ATTRIBUTES_MAPPING.key?(key.to_sym)

        attr_name = ATTRIBUTES_MAPPING[key.to_sym]
        @person[attr_name] =
          value.presence || (Person.type_for_attribute(attr_name).type == :string ? '-' : nil)
      end
    end

    def update_indirectly_mappable_attributes
      is_employed = @ptime_employee_attributes[:has_relevant_employment]
      @person.company = is_employed ? @employed_company : @unemployed_company
      @person.department = Department.find_or_create_by!(
        name: @ptime_employee_attributes[:department_name]
      )
      @person.marital_status = @ptime_employee_attributes[:marital_status]
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
