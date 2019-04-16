require 'rails_helper'

describe SynchronizeDataJob do
  let(:job) { SynchronizeDataJob.new }

  it 'marks deleted person as ex employee' do
    # allow_any_instance_of(SynchronizeDataJob).to receive(:response).and_return(employees_json(ex_employee_hash))

    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: empty_body)

    expect(Person.count).to eq(3)

    job.perform

    expect(Person.count).to eq(3)
    person = Person.find_by(puzzle_time_id: 42)
    expect(person.name).to eq('Tony Stark')
    expect(person.title).to eq('BSc in Informatics')
  end

  it 'creates new person' do
    allow_any_instance_of(SynchronizeDataJob).to receive(:response).and_return(employees_json(new_employee_hash))

    expect(Person.count).to eq(3)
    expect(Person.pluck(:puzzle_time_id).include?('42')).to eq(false)

    job.perform

    expect(Person.count).to eq(4)
    person = Person.find_by(puzzle_time_id: 42)
    expect(person.name).to eq('Tony Stark')
    expect(person.title).to eq('BSc in Informatics')
    expect(person.company_id).to eq(my_company.id)
    expect(person.nationality).to eq('US')
    expect(person.nationality2).to eq('CH')
    expect(person.marital_status).to eq('single')
    expect(person.email).to eq('ironman@example.ch')
    expect(person.department).to eq('D1')
  end

  private

  let(:empty_body) do
    '{"data":[{}]}'
  end

  let(:test) do
    '{"data":[{"id":112,"updated_at":"2018-09-19T08:24:32.211+02:00","type":"section"},
    {"id":100,"updated_at":"2018-09-20T15:41:42.475+02:00","type":"manual"}]}'
  end

  def bob
    @bob ||= people(:bob)
  end

  def my_company
    Company.find_by(company_type: 'mine')
  end

  def employees_json(hash)
    # generates json from hash
    JSON.generate('data': [hash])
  end

  def new_employee_hash
    {
      'id' => '42',
      'type' => 'employee',
      'attributes' => {
        'shortname' => 'TS',
        'firstname' => 'Tony',
        'lastname' => 'Stark',
        'email' => 'ironman@example.ch',
        'marital_status' => 'single',
        'nationalities' => ['US', 'CH'],
        'graduation' => 'BSc in Informatics',
        'department_shortname' => 'D1',
        'employment_roles' => [{
          'name' => 'Boss',
          'percent' => 100.00
        }]
      }
    }
  end
  
  def ex_employee_hash
    {
    }
  end
end
