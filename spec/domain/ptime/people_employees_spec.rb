require 'rails_helper'

describe Ptime::PeopleEmployees do
  subject(:people_employees) { described_class.new }

  before(:each) do
    enable_ptime_sync

    PersonRoleLevel.create!(level: 'S3')
    PersonRoleLevel.create!(level: 'S4')
    PersonRoleLevel.create!(level: 'S5')
  end

  it 'creates and updates people from ptime data' do
    # Longmax: Currently unemployed in skills DB -> Ptime data will update him to be employed
    # Emmeline: Not in skills DB -> Will be created from Ptime data
    # Charlie: Currently employed in skills Db -> Ptime data will update him to be unemployed
    # Bob: Currently employed in skills Db -> Will be updated with data from second ptime provider

    # Change email to make sure data is not updated for unemployed people
    updated_company_employees = ptime_company_employees
    updated_company_employees[:data].third[:attributes][:email] = 'charlie_ford@example.com'
    stub_ptime_request(*ptime_company_request_data.values, updated_company_employees.to_json)

    longmax = people(:longmax)
    charlie = people(:charlie)
    bob = people(:bob)

    longmax.update!(ptime_employee_id: 33)
    longmax.update!(ptime_data_provider: 'Firma')
    longmax.update!(company: Company.find_by(name: 'Ex-Mitarbeiter'))
    charlie.update!(ptime_employee_id: 45)
    charlie.update!(ptime_data_provider: 'Firma')
    bob.update!(ptime_employee_id: 23)
    bob.update!(ptime_data_provider: 'Partner')

    expect { people_employees.update_people_data }.to change(Person, :count).by(1)

    longmax.reload
    emmeline = Person.find_by(name: 'Emmeline Charlotte')
    charlie.reload
    bob.reload

    company_employee_data = updated_company_employees[:data]

    longmax_data = company_employee_data.first[:attributes]
    emmeline_data = company_employee_data.second[:attributes]
    charlie_data = company_employee_data.third[:attributes]
    bob_data = ptime_partner_employee_data.first[:attributes]

    check_person_data_updated(longmax, longmax_data)
    check_person_data_updated(emmeline, emmeline_data)
    check_person_data_updated(charlie, charlie_data)
    check_person_data_updated(bob, bob_data)
  end

  it 'should return a list with the names of the people for which the update failed if the manual sync is used' do
    longmax_attributes, bob_attributes = stub_invalid_ptime_response

    expect(Ptime::PeopleEmployees.new.update_people_data(is_manual_sync: true)).to eql({"Firma" => [employee_full_name(longmax_attributes)], "Partner" => [employee_full_name(bob_attributes)]})
  end

  it 'should throw custom exception when nightly job is used' do
    longmax_attributes, bob_attributes = stub_invalid_ptime_response

    expect { Ptime::PeopleEmployees.new.update_people_data }.to raise_error(PtimeExceptions::PersonUpdateWithPtimeDataFailed,
      "Something went wrong while updating #{employee_full_name(longmax_attributes)} from provider Firma and #{employee_full_name(bob_attributes)} from
      provider Partner. Please try again and, if necessary, check the data in PuzzleTime.".squish)
  end

  def check_person_data_updated(person, employee_data)
    is_employed = employee_data[:has_relevant_employment]

    expect(person.name.eql?(employee_full_name(employee_data))).to eql(is_employed)
    expect(person.email.eql?(employee_data[:email])).to eql(is_employed)
    expect(person.company.name).to eq(is_employed ? person.ptime_data_provider : 'Ex-Mitarbeiter')
    expect(person.marital_status.eql?(employee_data[:marital_status])).to eq(is_employed)
    expect(person.nationality.eql?(employee_data[:nationalities].first)).to eq(is_employed)
    expect(person.title.eql?(employee_data[:graduation])).to eq(is_employed)
    expect(person.location.eql?(employee_data[:city])).to eq(is_employed)
    expect(person.birthdate == employee_data[:birthday].to_date).to eq(is_employed)
    expect(person.department.name.eql?(employee_data[:department_name])).to eq(is_employed)

    check_person_roles_updated(person, employee_data) if is_employed
  end
  def check_person_roles_updated(person, employee_data)
    person.roles.each_with_index do |role, i|
      employment_role = employee_data[:employment_roles][i]

      expect(role.name).to eq(employment_role[:name].gsub(/\A[A-Z]\d+\s/, ''))
      person_role = person.person_roles[i]
      expect(person_role.percent).to eq(employment_role[:percent])
      expect(person_role.person_role_level.level).to eq(employment_role[:role_level])
    end
  end
end
