require 'rails_helper'

describe PeopleSync::MarkExEmployeesTask do
  # bob is no longer an employee and has been removed
  let(:employees) do
    []
  end

  context 'mark ex employees' do
    it 'marks removed people as ex employees' do
      bob = Person.find_by(name: 'Bob Anderson')
      expect(bob.company.company_type).to eq('mine')

      PeopleSync::MarkExEmployeesTask.mark_ex_employees(employees)
     
      bob = Person.find_by(name: 'Bob Anderson')
      expect(bob.company.company_type).to eq('external')
    end
  end
end
