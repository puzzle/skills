require 'rails_helper'

describe PuzzleTime do
  let(:people_json) do
    '{"data": [
       {
         "id": "42",
         "type": "employee",
         "attributes":{
           "shortname": "TS","firstname": "Tony","lastname": "Stark",
           "email": "ironman@example.ch","marital_status": "single",
           "nationalities": ["US","CH"],"graduation": "BSc in Informatics",
           "department_shortname": "D1",
           "employment_roles": [{"name": "Boss","percent": 90.00}]
         }
       },
       {
         "id": "43",
         "type": "employee",
         "attributes":{
           "shortname": "SR","firstname": "Steven","lastname": "Rogers",
           "email": "captain-america@example.ch","marital_status": "married",
           "nationalities": ["CH"],"graduation": "MSc in Informatics",
           "department_shortname": "Sys",
           "employment_roles": [{"name": "Trainee","percent": 100.00}]
         }
       }
    ]}'
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
      "id"=>"43",
      "type"=>"employee",
      "attributes"=> {
        "shortname"=>"SR",
        "firstname"=>"Steven",
        "lastname"=>"Rogers",
        "email"=>"captain-america@example.ch",
        "marital_status"=>"married",
        "nationalities"=>["CH"],
        "graduation"=>"MSc in Informatics",
        "department_shortname"=>"Sys",
        "employment_roles"=>[{"name"=>"Trainee", "percent"=>100.0}]
      }
    }]
  end

  context 'check config' do
    it 'returns false if config missing' do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return(nil)
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return(nil)
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return(nil)

      expect(puzzle_time.config_valid?).to eq(false)
    end
    
    it 'returns false if url missing' do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return('bob')
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return('password')
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return(nil)

      expect(puzzle_time.config_valid?).to eq(false)
    end
    
    it 'returns false if username missing' do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return(nil)
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return('password')
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return('http://localhost:4000/api/v1/employees')

      expect(puzzle_time.config_valid?).to eq(false)
    end
    
    it 'returns false if password missing' do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return('bob')
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return(nil)
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return('http://localhost:4000/api/v1/employees')

      expect(puzzle_time.config_valid?).to eq(false)
    end
    
    it 'returns false if config present but url invalid' do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return('bob')
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return('password')
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return('invalid url')

      expect(puzzle_time.config_valid?).to eq(false)
    end
    
    it 'returns true if config present and url valid' do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return('bob')
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return('password')
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return('http://localhost:4000/api/v1/employees')

      expect(puzzle_time.config_valid?).to eq(true)
    end
  end

  context 'people' do
    before do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return('bob')
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return('password')
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return('http://localhost:4000/api/v1/employees')
    end

    it 'parses and returns people' do
      stub_request(:get, 'http://localhost:4000/api/v1/employees').
        to_return(status: [200, 'OK'], body: people_json)

      expect(puzzle_time.people).to eq(people_hash)
    end
  end
  
  context 'updated people' do
    before do
      allow(ENV).to receive(:[])     
      allow(ENV).to receive(:[])
        .with('RAILS_API_USER')
        .and_return('bob')
      allow(ENV).to receive(:[])
        .with('RAILS_API_PASSWORD')
        .and_return('password')
      allow(ENV).to receive(:[])
        .with('RAILS_API_URL')
        .and_return('http://localhost:4000/api/v1/employees')
    end

    it 'parses and returns people people because last runned job is missing' do
      stub_request(:get, 'http://localhost:4000/api/v1/employees').
        to_return(status: [200, 'OK'], body: people_json)

      expect(puzzle_time.updated_people).to eq(people_hash)
    end
    
    it 'parses and returns updated people' do
      url = 'http://localhost:4000/api/v1/employees?'
      query_param = 'last_run_at=2001-01-01%2000:00:00%20UTC'

      stub_request(:get, "#{url}#{query_param}").
        to_return(status: [200, 'OK'], body: people_json)
      
      last_runned_at = DateTime.new(2001, 1, 1)
      delayed_job = Delayed::Job.create!(
                           handler: '',
                           queue: 'sync_data',
                           cron: '* * * * *')
      delayed_job.update_attribute(:run_at, last_runned_at)

      expect(puzzle_time.updated_people).to eq(people_hash)
    end
  end

  private

  def puzzle_time
    @puzzle_time ||= PuzzleTime.new
  end
end
