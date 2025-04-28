require 'rails_helper'

describe Ptime::PeopleEmployees do
  subject(:people_employees) { described_class.new }

  before(:each) do
    enable_ptime_sync

    Company.create!(name: 'Firma')
    Company.create!(name: 'Ex-Mitarbeiter')

    PersonRoleLevel.create!(level: 'S3')
    PersonRoleLevel.create!(level: 'S4')
    PersonRoleLevel.create!(level: 'S5')
  end

  it 'creates and updates people from ptime data' do
    longmax = people(:longmax)
    charlie = people(:charlie)

    longmax.update!(ptime_employee_id: 33)
    charlie.update!(ptime_employee_id: 45)

    expect { people_employees.update_people_data }.to change(Person, :count).by(1)

    longmax.reload
    emmeline = Person.find_by(name: 'Emmeline Charlotte')
    charlie.reload

    employee_data = ptime_employees_data
    longmax_data = employee_data.first[:attributes]
    emmeline_data = employee_data.second[:attributes]
    charlie_data = employee_data.third[:attributes]

    charlie_data[:email] = 'charlie_ford@example.com'

    check_person_data_updated(longmax, longmax_data)
    check_person_data_updated(emmeline, emmeline_data)
    check_person_data_updated(charlie, charlie_data)
  end

  def check_person_data_updated(person, employee_data)
    is_employed = employee_data[:is_employed]

    expect(person.email.eql?(employee_data[:email])).to eql(is_employed)
    expect(person.company.name).to eq(is_employed ? 'Firma' : 'Ex-Mitarbeiter')
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
