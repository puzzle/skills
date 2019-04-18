require 'rails_helper'

describe PuzzleTime::CreateRolesTask do
  let(:person_with_new_roles) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"BA",
        "firstname"=>"Bob",
        "lastname"=>"Anderson",
        "email"=>"anderson@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[
          {"name"=>"Software-Engineer", "percent"=>50.0},
          {"name"=>"Teamleader", "percent"=>30.0},
          {"name"=>"Project Owner", "percent"=>20.0}
        ]
      }
    }]
  end

  let(:person_with_existing_roles) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"BA",
        "firstname"=>"Bob",
        "lastname"=>"Anderson",
        "email"=>"anderson@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[
          {"name"=>"Software-Engineer", "percent"=>50.0},
          {"name"=>"System-Engineer", "percent"=>30.0},
          {"name"=>"Scrummaster", "percent"=>20.0}
        ]
      }
    }]
  end

  context 'create roles' do
    it 'creates new roles' do
      expect(Role.all.pluck(:name)).to eq(['Software-Engineer',
                                           'System-Engineer',
                                           'Scrummaster'])

      PuzzleTime::CreateRolesTask.create_roles(person_with_new_roles)

      expect(Role.all.pluck(:name)).to eq(['Software-Engineer',
                                           'System-Engineer',
                                           'Scrummaster',
                                           'Teamleader',
                                           'Project Owner'])
    end

    it 'does not create existing roles' do
      expect(Role.all.pluck(:name)).to eq(['Software-Engineer',
                                           'System-Engineer',
                                           'Scrummaster'])

      PuzzleTime::CreateRolesTask.create_roles(person_with_existing_roles)

      expect(Role.all.pluck(:name)).to eq(['Software-Engineer',
                                           'System-Engineer',
                                           'Scrummaster'])
    end
  end
end
