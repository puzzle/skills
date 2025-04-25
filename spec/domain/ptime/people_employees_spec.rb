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
    longmax = Person.find_by(name: 'Longmax Smith')
    charlie = Person.find_by(name: 'Charlie Ford')

    longmax.update!(ptime_employee_id: 33)
    charlie.update!(ptime_employee_id: 45)

    expect { people_employees.update_people_data }.to change(Person, :count).by(1)

    emmeline = Person.find_by(name: 'Emmeline Charlotte')
    longmax.reload
    charlie.reload

    expect(longmax.email).to eq('longmax@example.com')
    expect(longmax.company.name).to eq('Firma')
    expect(longmax.marital_status).to eq('married')
    expect(longmax.nationality).to eq('US')
    expect(longmax.title).to eq('Flashing lights')
    expect(longmax.location).to eq('Bern')
    expect(longmax.birthdate.to_s).to eq('1990-03-10 00:00:00 UTC')
    expect(longmax.department.name).to eq('/ux')
    expect(longmax.roles.first.name).to eq('UX Consultant')

    longmax_person_role = PersonRole.find_by_person_id(longmax.id)
    expect(longmax_person_role.percent).to eq(100.0)
    expect(longmax_person_role.person_role_level_id).to eq(PersonRoleLevel.find_by_level('S4').id)

    expect(emmeline.email).to eq('emmeline@example.com')
    expect(emmeline.company.name).to eq('Firma')
    expect(emmeline.marital_status).to eq('single')
    expect(emmeline.nationality).to eq('DE')
    expect(emmeline.title).to eq('MSc in writing')
    expect(emmeline.location).to eq('Genf')
    expect(emmeline.birthdate.to_s).to eq('2001-01-05 00:00:00 UTC')
    expect(emmeline.department.name).to eq('/dev/tre')
    expect(emmeline.roles.first.name).to eq('Software Engineer')

    emmeline_person_role = PersonRole.find_by_person_id(emmeline.id)
    expect(emmeline_person_role.percent).to eq(80.0)
    expect(emmeline_person_role.person_role_level_id).to eq(PersonRoleLevel.find_by_level('S5').id)

    expect(charlie.company.name).to eq('Ex-Mitarbeiter') # Not employed
    expect(charlie.email).not_to eq('charlieford@example.com')
    expect(charlie.marital_status).not_to eq('married')
    expect(charlie.nationality).not_to eq('CX')
    expect(charlie.title).not_to eq("Can't tell me nothing")
    expect(charlie.location).not_to eq('Thun')
    expect(charlie.department.name).not_to eq('/ux')
    expect(charlie.roles.first.name).not_to eq('Architect')

  end
end
