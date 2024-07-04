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

    def update_person_data(person)
      attribute_mapping = { shortname: :shortname, email: :email, marital_status: :marital_status,
                            graduation: :title, company: :company, birthdate: :birthdate,
                            location: :location, nationality: :nationality }.freeze

      begin
        return unless person.ptime_employee_id

        ptime_employee = Ptime::Client.new.get("employees/#{person.ptime_employee_id}")['data']
      rescue RestClient::NotFound
        raise "Ptime_employee with id #{person.ptime_employee_id} not found"
      rescue StandardError
        nil
      else
        ptime_employee_firstname = ptime_employee['attributes']['firstname']
        ptime_employee_lastname = ptime_employee['attributes']['lastname']
        ptime_employee_name = "#{ptime_employee_firstname} #{ptime_employee_lastname}"
        person.name = ptime_employee_name
        ptime_employee['attributes'].each do |key, value|
          if key.to_sym.in?(attribute_mapping.keys)
            person[attribute_mapping[key.to_sym]] = (value.presence || '-')
          end
        end
        person.save!
      end
    end
  end
end
