require 'rails_helper'

describe PeopleSync::CreatePeopleTask do

  let(:new_person) do
    [{
      "id"=>"58",
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

  let(:existing_person) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"BA",
        "firstname"=>"Bob",
        "lastname"=>"Anderson",
        "email"=>"bob@example.com",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D3",
        "employment_roles"=>[
          {"name"=>"Software-Engineer", "percent"=>50.0},
        ]
      }
    }]
  end

  context 'create people' do
    it 'creates new person' do
      expect(Person.count).to eq(3)
      expect(Person.pluck(:remote_key).include?(58)).to eq(false)

      PeopleSync::CreatePeopleTask.create_people(new_person)

      expect(Person.count).to eq(4)
      person = Person.find_by(remote_key: 58)
      expect(person.name).to eq('Bruce Banner')
      expect(person.title).to eq('MSc in Informatics')
      expect(person.nationality).to eq('US')
      expect(person.nationality2).to eq('CH')
      expect(person.marital_status).to eq('single')
      expect(person.email).to eq('hulk@example.ch')
      expect(person.department).to eq('D3')
    end

    it 'does not create existing person' do
      expect(Person.count).to eq(3)
      expect(Person.pluck(:remote_key).include?(42)).to eq(true)

      PeopleSync::CreatePeopleTask.create_people(existing_person)

      expect(Person.count).to eq(3)
      person = Person.find_by(remote_key: 42)
      expect(person.name).to eq('Bob Anderson')
      expect(person.title).to eq('BSc in Cleaning')
      expect(person.nationality).to eq('CH')
      expect(person.nationality2).to eq('SE')
      expect(person.marital_status).to eq('single')
      expect(person.email).to eq('bob@example.com')
      expect(person.department).to eq('/sys')
    end
  end
end
