require 'rails_helper'

describe PuzzleTime::PeopleFilter do
  let(:empty) do
    []
  end

  let(:people_hash) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    },
    {
      "id"=>43,
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>nil,
        "firstname"=>nil,
        "lastname"=>nil,
        "email"=>nil,
        "marital_status"=>"married",
        "nationalities"=>["CH"],
        "graduation"=>"MSc in Informatics",
        "department_shortname"=>"Sys",
        "employment_roles"=>[{"name"=>"Trainee", "percent"=>100.0}]
      }
    }]
  end
  
  let(:valid_person) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end
  
  let(:person_without_puzzle_time_key) do
    [{
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end
  
  let(:person_with_invalid_puzzle_time_key) do
    [{
      "id"=>"text",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end
  
  let(:person_with_negative_puzzle_time_key) do
    [{
      "id"=>"-42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end

  let(:person_with_a_missing_attribute) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end

  let(:person_with_an_empty_attribute) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>nil,
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end
  
  let(:person_with_invalid_nationalities) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>"US",
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}]
      }
    }]
  end
  
  let(:person_with_invalid_roles) do
    [{
      "id"=>"42",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"TS",
        "firstname"=>"Tony",
        "lastname"=>"Stark",
        "email"=>"ironman@example.ch",
        "marital_status"=>"single",
        "nationalities"=>["US", "CH"],
        "graduation"=>"BSc in Informatics",
        "department_shortname"=>"D1",
        "employment_roles"=>[{}]
      }
    }]
  end
  
  let(:invalid_person_hash) do
    [{
      "id"=>"42",
      "type"=>"employee",
    }]
  end

  context 'filter people' do
    it 'returns an empty array if people missing' do
      expect(PuzzleTime::PeopleFilter.new(empty).filter).to eq([])
    end
    
    it 'returns only valid people' do
      expect(PuzzleTime::PeopleFilter.new(people_hash).filter).to eq(valid_person)
    end
    
    it 'does not return person without puzzle time key' do
      expect(PuzzleTime::PeopleFilter.new(person_without_puzzle_time_key).filter).to eq([])
    end

    it 'does not return person if puzzle time key not a number' do
      expect(PuzzleTime::PeopleFilter.new(person_with_invalid_puzzle_time_key).filter).to eq([])
    end
    
    it 'does not return person if puzzle time key is a negative number' do
      expect(PuzzleTime::PeopleFilter.new(person_with_negative_puzzle_time_key).filter).to eq([])
    end
    
    it 'does not return person if an attribute is missing' do
      expect(PuzzleTime::PeopleFilter.new(person_with_a_missing_attribute).filter).to eq([])
    end
    
    it 'does not return person if an attribute is nil' do
      expect(PuzzleTime::PeopleFilter.new(person_with_an_empty_attribute).filter).to eq([])
    end
    
    it 'does not return person if nationalities not an array' do
      expect(PuzzleTime::PeopleFilter.new(person_with_invalid_nationalities).filter).to eq([])
    end
    
    it 'does not return person if roles invalid' do
      expect(PuzzleTime::PeopleFilter.new(person_with_invalid_roles).filter).to eq([])
    end
    
    it 'does not return person if hash invalid' do
      expect(PuzzleTime::PeopleFilter.new(invalid_person_hash).filter).to eq([])
    end
  end
end
