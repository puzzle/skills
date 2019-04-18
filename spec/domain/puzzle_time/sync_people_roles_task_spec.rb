require 'rails_helper'

describe PuzzleTime::SyncPeopleRolesTask do
  let(:person_with_roles) do
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
          {"name"=>"Scrummaster", "percent"=>50.0},
          {"name"=>"Software-Engineer", "percent"=>50.0}
        ]
      }
    }]
  end
  
  let(:person_with_existing_role) do
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
          {"name"=>"Software-Engineer", "percent"=>50.0}
        ]
      }
    }]
  end
  
  let(:person_with_removed_and_new_role) do
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
          {"name"=>"Scrummaster", "percent"=>50.0}
        ]
      }
    }]
  end
  
  let(:person_with_removed_role) do
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
        ]
      }
    }]
  end

  context 'sync people roles' do
    it 'creates new people roles' do
      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(1)
      role_ids = bob.people_roles.pluck(:role_id)
      expect(Role.where(id: role_ids).pluck(:name)).to eq(['Software-Engineer'])
      
      PuzzleTime::SyncPeopleRolesTask.sync_people_roles(person_with_roles)

      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(2)
      role_ids = bob.people_roles.pluck(:role_id)
      expect(Role.where(id: role_ids).pluck(:name)).to eq(['Software-Engineer', 'Scrummaster'])
    end
    
    it 'does not create already existing people role' do
      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(1)
      role_ids = bob.people_roles.pluck(:role_id)
      expect(Role.where(id: role_ids).pluck(:name)).to eq(['Software-Engineer'])
      
      PuzzleTime::SyncPeopleRolesTask.sync_people_roles(person_with_existing_role)

      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(1)
      role_ids = bob.people_roles.pluck(:role_id)
      expect(Role.where(id: role_ids).pluck(:name)).to eq(['Software-Engineer'])
    end
  
    it 'deletes removed people roles' do
      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(1)
      role_ids = bob.people_roles.pluck(:role_id)
        expect(Role.where(id: role_ids).pluck(:name)).to eq(['Software-Engineer'])
      
      PuzzleTime::SyncPeopleRolesTask.sync_people_roles(person_with_removed_role)

      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(0)
      role_ids = bob.people_roles.pluck(:role_id)
      expect(Role.where(id: role_ids).pluck(:name)).to eq([])
    end
  
    it 'deletes and creates people roles' do
      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(1)
      role_ids = bob.people_roles.pluck(:role_id)
        expect(Role.where(id: role_ids).pluck(:name)).to eq(['Software-Engineer'])
      
      PuzzleTime::SyncPeopleRolesTask.sync_people_roles(person_with_removed_and_new_role)

      bob = Person.find_by(puzzle_time_key: 42)  
      expect(bob.people_roles.count).to eq(1)
      role_ids = bob.people_roles.pluck(:role_id)
      expect(Role.where(id: role_ids).pluck(:name)).to eq(['Scrummaster'])
    end
  end
end
