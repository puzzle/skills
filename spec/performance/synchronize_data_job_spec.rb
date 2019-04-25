require 'rails_helper'

describe SynchronizeDataJob, performance: true do
  let(:job) { SynchronizeDataJob.new }
  
  before do
    allow(ENV).to receive(:[])     
    allow(ENV).to receive(:[]).with('RAILS_API_USER').and_return('bob')
    allow(ENV).to receive(:[]).with('RAILS_API_PASSWORD').and_return('password')
    allow(ENV).to receive(:[]).with('RAILS_API_URL').and_return('http://localhost:4000/api/v1/employees')
  end
  
  it 'synchronizes 10 people' do
    people_count = 10
    people = load_people(people_count)
    before = get_memory_usage_kb

    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: people)

    expect(Person.count).to eq(3)

    job.perform

    expect(Person.count).to eq(people_count + 2)

    after = get_memory_usage_kb
    puts "Memory: #{(after - before) / 1000.0} mb"
  end
  
  it 'synchronizes 1000 people' do
    people_count = 1000
    people = load_people(people_count)
    before = get_memory_usage_kb

    stub_request(:get, 'http://localhost:4000/api/v1/employees').
      to_return(status: [200, 'OK'], body: people)

    expect(Person.count).to eq(3)

    job.perform

    expect(Person.count).to eq(people_count + 1)

    after = get_memory_usage_kb
    puts "Memory: #{(after - before) / 1000.0} mb"
  end

  private

  def load_people(number)
    JSON.generate('data': people(number))
  end

  def people(number)
    number.times.map do |id|
      {
        'id' => id,
        'type' => 'employee',
        'attributes' => {
          'shortname' => Faker::Name.initials,
          'firstname' => Faker::Name.first_name,
          'lastname' => Faker::Name.last_name,
          'email' => Faker::Internet.email,
          'marital_status' => ['single', 'married'].sample,
          'nationalities' => ['CH'],
          'graduation' => Faker::Job.education_level,
          'department_shortname' => ['sys', 'ux', 'mid'].sample,
          'employment_roles' => [{'name' => Faker::Job.position, 'percent' => 100.00}]
        }
      }
    end
  end
end
