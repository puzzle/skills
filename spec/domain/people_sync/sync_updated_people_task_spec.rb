require 'rails_helper'

describe PeopleSync::SyncUpdatedPeopleTask do

  let(:updated_person) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"BB",
        "firstname"=>"Bruce",
        "lastname"=>"Banner",
        "email"=>"hulk@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"MSc in Informatics",
        "department_shortname"=>"D3",
        "employment_roles"=>[
          {"name"=>"Software-Engineer", "percent"=>80.0},
        ]
      }
    }]
  end

  context 'synchronize updated people' do
    it 'synchronizes updated person' do
      expect(Person.count).to eq(3)
      person = Person.find_by(remote_key: 42)
      expect(person.name).to eq('Bob Anderson')
      expect(person.title).to eq('BSc in Cleaning')
      expect(person.nationality).to eq('CH')
      expect(person.nationality2).to eq('SE')
      expect(person.marital_status).to eq('single')
      expect(person.email).to eq('bob@example.com')
      expect(person.department).to eq('/sys')

      PeopleSync::SyncUpdatedPeopleTask.sync_updated_people(updated_person)

      expect(Person.count).to eq(3)
      person = Person.find_by(remote_key: 42)
      expect(person.name).to eq('Bruce Banner')
      expect(person.title).to eq('MSc in Informatics')
      expect(person.nationality).to eq('US')
      expect(person.nationality2).to eq('CH')
      expect(person.marital_status).to eq('single')
      expect(person.email).to eq('hulk@example.ch')
      expect(person.department).to eq('D3')
    end
  end
end
