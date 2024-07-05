module Ptime
  class UpdatePersonData
    def create_person(ptime_employee_id)
      raise 'No ptime_employee_id provided' unless ptime_employee_id

      person = Person.find_by(ptime_employee_id: ptime_employee_id)
      return person unless person.nil?

      Person.create!(name: 'Default name', company: Company.first, birthdate: '1.1.1970',
                     nationality: 'CH', location: 'Bern', title: 'Default title',
                     email: 'default@example.com', ptime_employee_id: ptime_employee_id)
    end

    # rubocop:disable Metrics
    def update_person_data(person)
      attribute_mapping = { full_name: :name, shortname: :shortname, email: :email, marital_status:
                            :marital_status, graduation: :title, birthdate: :birthdate,
                            location: :location }.freeze

      begin
        return unless person.ptime_employee_id

        ptime_employee = Ptime::Client.new.get("employees/#{person.ptime_employee_id}")['data']
      rescue RestClient::NotFound
        person.destroy! if person.created_at == person.updated_at
        raise "Ptime_employee with id #{person.ptime_employee_id} not found"
      rescue StandardError
        nil
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
        person.destroy! if !person.valid? && person.created_at == person.updated_at
        person.save!
      end
    end
    # rubocop:enable Metrics
  end
end
