require 'rails_helper'

describe SynchronizePersonJob do
  let(:job) { SynchronizePersonJob }

  let(:my_company) { Company.find_by(company_type: 'mine') }
  
  let(:external_company) { Company.find_by(company_type: 'external') }

  let(:empty_json) { '{"data":[]}' }
  
  let(:invalid_json) { '{"data":["invalid"]}' }

  let(:new_person_json) do
    '{"data": [{
      "id": "99",
      "type": "employee",
      "attributes":{
        "shortname": "TS","firstname": "Tony","lastname": "Stark",
        "email": "ironman@example.ch","marital_status": "single",
        "nationalities": ["US","CH"],"graduation": "BSc in Informatics",
        "department_shortname": "D1",
        "employment_roles": [{"name": "Boss","percent": 90.00}]
      }
    }]}'
  end

  let(:updated_person_json) do
    '{"data": [{
      "id": "99",
      "type": "employee",
      "attributes":{
        "shortname": "BB","firstname": "Bruce","lastname": "Banner",
        "email": "hulk@example.ch","marital_status": "married",
        "nationalities": ["FR","IT"],"graduation": "Student",
        "department_shortname": "D2",
        "employment_roles": [{"name": "Trainee","percent": 70.00}]
      }
    }]}'
  end
  
  let(:person_with_missing_attributes_json) do
    '{"data": [{
      "id": "99",
      "type": "employee",
      "attributes":{
        "email": "ironman@example.ch","marital_status": "single",
        "nationalities": ["US","CH"],"graduation": "BSc in Informatics",
        "department_shortname": "D1",
        "employment_roles": [{"name": "Boss","percent": 90.00}]
      }
    }]}'
  end

  before do
    allow(ENV).to receive(:[])     
    allow(ENV).to receive(:[]).with('RAILS_API_USER').and_return('bob')
    allow(ENV).to receive(:[]).with('RAILS_API_PASSWORD').and_return('password')
    allow(ENV).to receive(:[]).with('RAILS_API_URL').and_return('http://localhost:4000/api/v1/employees')
  end

  it 'marks deleted person as ex employee' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: empty_json)

    person = Person.find_by(remote_key: 42)
    expect(Person.count).to eq(3)
    expect(person.company_id).to eq(my_company.id)

    job.perform

    person = Person.find_by(remote_key: 42)
    expect(Person.count).to eq(3)
    expect(person.company_id).to eq(external_company.id)
  end

  it 'creates new person' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: new_person_json)

    expect(Person.count).to eq(3)
    expect(Person.pluck(:remote_key).include?(99)).to eq(false)

    job.perform

    expect(Person.count).to eq(4)
    person = Person.find_by(remote_key: 99)
    expect(person.name).to eq('Tony Stark')
    expect(person.title).to eq('BSc in Informatics')
    expect(person.company_id).to eq(my_company.id)
    expect(person.nationality).to eq('US')
    expect(person.nationality2).to eq('CH')
    expect(person.marital_status).to eq('single')
    expect(person.email).to eq('ironman@example.ch')
    expect(person.department).to eq('D1')

    people_role = person.people_roles[0]
    expect(person.people_roles.count).to eq(1)
    expect(people_role.percent).to eq(90.00)
    expect(people_role.role.name).to eq('Boss')
  end
  
  it 'creates new person and updates person' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: new_person_json)

    expect(Person.count).to eq(3)
    expect(Person.pluck(:remote_key).include?(99)).to eq(false)

    job.perform

    expect(Person.count).to eq(4)
    person = Person.find_by(remote_key: 99)
    expect(person.name).to eq('Tony Stark')
    expect(person.title).to eq('BSc in Informatics')
    expect(person.company_id).to eq(my_company.id)
    expect(person.nationality).to eq('US')
    expect(person.nationality2).to eq('CH')
    expect(person.marital_status).to eq('single')
    expect(person.email).to eq('ironman@example.ch')
    expect(person.department).to eq('D1')

    people_role = person.people_roles[0]
    expect(person.people_roles.count).to eq(1)
    expect(people_role.percent).to eq(90.00)
    expect(people_role.role.name).to eq('Boss')
    
    delayed_job = instance_double('Delayed::Job', run_at: DateTime.new(2001, 1, 1))
    allow(Delayed::Job).to receive(:where) { [delayed_job] }
    
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: updated_person_json)

    stub_request(:get, 'http://localhost:4000/api/v1/employees?update_since=2001-01-01T00:00:00%2B00:00').
      to_return(status: [200, 'OK'], body: updated_person_json)
    
    job.perform
    
    expect(Person.count).to eq(4)
    person = Person.find_by(remote_key: 99)
    expect(person.name).to eq('Bruce Banner')
    expect(person.title).to eq('Student')
    expect(person.company_id).to eq(my_company.id)
    expect(person.nationality).to eq('FR')
    expect(person.nationality2).to eq('IT')
    expect(person.marital_status).to eq('married')
    expect(person.email).to eq('hulk@example.ch')
    expect(person.department).to eq('D2')

    people_role = person.people_roles[0]
    expect(person.people_roles.count).to eq(1)
    expect(people_role.percent).to eq(70.00)
    expect(people_role.role.name).to eq('Trainee')
  end
  
  it 'does not create person if json invalid' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: invalid_json)

    expect(Person.count).to eq(3)
    expect(Person.pluck(:remote_key).include?(99)).to eq(false)
    expect(Airbrake).to receive(:notify)
      .with("person not valid", {:person=>"invalid"})
      .at_least(:once)

    job.perform
    
    expect(Person.count).to eq(3)
    expect(Person.pluck(:remote_key).include?(99)).to eq(false)
  end

  it 'does not create person if missing attributes' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: person_with_missing_attributes_json)

    expect(Person.count).to eq(3)
    expect(Person.pluck(:remote_key).include?(99)).to eq(false)
    expect(Airbrake).to receive(:notify)
      .with("person not valid", {:person=>
                                   {"attributes"=>
                                      {"department_shortname"=>"D1",
                                       "email"=>"ironman@example.ch",
                                       "employment_roles"=>[{"name"=>"Boss", "percent"=>90.0}],
                                       "graduation"=>"BSc in Informatics",
                                       "marital_status"=>"single",
                                       "nationalities"=>["US", "CH"]},
                                       "id"=>"99",
                                       "type"=>"employee"}})
      .at_least(:once)

    job.perform

    expect(Person.count).to eq(3)
    expect(Person.pluck(:remote_key).include?(99)).to eq(false)
  end
  
  it 'raises error if credentials false' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [401, 'Unauthorized'])

    expect do
      job.perform
    end.to raise_error('unauthorized')
  end
  
  it 'raises error if server not available' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_raise(Errno::ECONNREFUSED)

    expect do
      job.perform
    end.to raise_error('server not available')
  end

  it 'raises error if connection timeout' do
    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_raise(Errno::ETIMEDOUT)

    expect do
      job.perform
    end.to raise_error('connection timeout')
  end
end
