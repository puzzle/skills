require 'net/http'
require 'uri'
require 'json'

class SynchronizeDataJob < CronJob
  PERSON_ATTRIBUTES = ['firstname', 'lastname', 'email', 'marital_status',
                       'graduation', 'department_shortname'].freeze

  queue_as :sync_data

  # Everyday at 02:47
  # self.cron_expression = '47 2 * * *'

  # Every minute for testing
  self.cron_expression = '* * * * *'

  def perform
    return unless config_present?
    return unless url_valid?

    create_new_roles
    mark_ex_employees
    create_new_employees
    synchronize_updated_employees
  end

  private

  def mark_ex_employees
    Person.where(id: ex_employee_ids).update_all(company_id: external_company_id)
  end

  def create_new_employees
    @people_roles = []

    create_new_people
    create_new_people_roles
  end

  def synchronize_updated_employees
    @people_roles = []

    synchronize_updated_people
    create_new_people_roles
  end

  def create_new_roles
    if all_role_names
      Role.create!(new_role_attributes)
    end
  end

  def new_role_attributes
    new_role_names.collect do |new_role_name|
      Hash['name', new_role_name]
    end
  end
  
  def new_role_names
    all_role_names.map do |role_name|
      Role.exists?(:name => role_name)? nil : role_name 
    end.compact
  end
  
  def all_role_names
    @all_role_names ||= all_people_attributes.map do |person|
      person['employment_roles'].map do |person_roles|
        person_roles.values[0]
      end.first
    end.uniq
  end
  
  def create_new_people
    new_people_attributes.map do |new_person|
      # set people roles
      pid = new_person['puzzle_time_id']
      employment_roles = new_person.delete('employment_roles')
      set_people_roles(employment_roles, pid)

      # set full name
      firstname = new_person.delete('firstname')
      lastname =  new_person.delete('lastname')
      new_person['name'] = "#{firstname} #{lastname}"

      # rename attributes
      new_person['title'] = new_person.delete('graduation')
      new_person['department'] = new_person.delete('department_shortname')

      # delete attributes
      new_person.delete('shortname')

      # set first and second nationality
      nationalities = new_person.delete('nationalities')
      new_person['nationality'] = nationalities.first
      new_person['nationality2'] = nationalities.second

      # set mandatory attributes that api does not include
      new_person['company_id'] = my_company_id
      new_person['birthdate'] = example_birthdate
      new_person['location'] = 'Bern'
    end

    Person.create!(new_people_attributes)
  end

  def synchronize_updated_people
    updated_people_attributes.each do |new_person|
      # set people roles
      pid = new_person['puzzle_time_id']
      employment_roles = new_person.delete('employment_roles')
      filtered_people_roles = filter_people_roles(employment_roles, pid)
      set_people_roles(filtered_people_roles, pid)

      # set full name
      firstname = new_person.delete('firstname')
      lastname =  new_person.delete('lastname')
      new_person['name'] = "#{firstname} #{lastname}"

      # rename attributes
      new_person['title'] = new_person.delete('graduation')
      new_person['department'] = new_person.delete('department_shortname')

      # delete attributes
      new_person.delete('shortname')

      # set first and second nationality
      nationalities = new_person.delete('nationalities')
      new_person['nationality'] = nationalities.first
      new_person['nationality2'] = nationalities.second

      Person.find_by(puzzle_time_id: pid).update_attributes!(new_person)
    end
  end

  def filter_people_roles(people_roles, pid)
    people_roles.map do |people_role|
      people_role if people_role_new?(people_role, pid)
    end.compact
  end
  
  def people_role_new?(people_role, pid)
    person = Person.find_by(puzzle_time_id: pid)
    person_role_names = person.roles.pluck(:name)
    return if person_role_names.include?(people_role['name'])
    true
  end

  def set_people_roles(people_roles, pid)
    @people_roles << people_roles.map do |people_role|
      people_role.merge!('pid' => pid)
    end.first
    @people_roles = @people_roles.compact
  end

  def create_new_people_roles
    @people_roles.map do |people_role| 
      # maybe select is faster than find
      
      # set person id
      pid = people_role.delete('pid')
      people_role['person_id'] = Person.find_by(puzzle_time_id: pid).id

      # set role id
      role_name = people_role.delete('name')
      people_role['role_id'] = Role.find_by(name: role_name).id
    end

    PeopleRole.create!(@people_roles)
  end

  def new_ids
    puzzle_time_ids - puzzle_skills_ids
  end

  def ex_employee_ids
    puzzle_skills_ids - puzzle_time_ids
  end

  def puzzle_time_ids
    @puzzle_time_ids ||= all_people_hash.map { |person| person.values[0].to_i }
  end

  def puzzle_skills_ids
    @puzzle_skills_ids ||= Person.all.pluck(:puzzle_time_id).compact
  end
  
  def updated_ids
    updated_people_hash.map { |updated_person| updated_person.values[0].to_i }
  end
  
  def all_people_attributes
    @all_people_attributes ||= all_people_hash.map do |person|
      pid = person.values[0].to_i
        person.values[2].merge!('puzzle_time_id' => pid)
    end.compact
  end

  def new_people_attributes
    @new_people_attributes ||= all_people_hash.map do |person|
      pid = person.values[0].to_i
      if new_ids.include? pid
        person.values[2].merge!('puzzle_time_id' => pid)
      end
    end.compact
  end
  
  def updated_people_attributes
    @updated_people_attributes ||= updated_people_hash.map do |updated_person|
      pid = updated_person.values[0].to_i
        updated_person.values[2].merge!('puzzle_time_id' => pid)
    end.compact
  end

  def all_people_hash
    all_people_hash = JSON.parse(response)['data']
    filter_people(all_people_hash)
  end
  
  def updated_people_hash
    last_runned_job = Delayed::Job.where(queue: 'sync_data').last
    if last_runned_job
      params = { last_run_at: last_runned_job.run_at }
      updated_people_hash = JSON.parse(response(params))['data']
      filter_people(updated_people_hash)
    else
      all_people_hash
    end
  end

  # returns array with hashes of valid people
  def filter_people(people_hash)
    people_hash.map do |person_hash|
      if person_valid?(person_hash)
        person_hash
      else
        Airbrake.notify('person not valid')
        nil
      end
    end.compact
  end

  def person_valid?(person_hash)
    # checks if pid is a positive number
    pid = person_hash.values[0]
    return unless is_a_positive_number?(pid)

    # checks all person attributes which should be strings 
    person_attributes = person_hash.values[2]
    PERSON_ATTRIBUTES.each do |attribute|
      return unless person_attributes[attribute].is_a?(String)
    end

    # checks nationalities
    return unless person_attributes['nationalities'].is_a?(Array)

    # checks roles
    person_attributes['employment_roles'].each do |role|
      return unless role['name'].is_a?(String)
      return unless role['percent'].is_a?(Float)
    end
    true
  end

  # Get person data from API
  def response(params = nil)
    uri = uri(params)
    http = http(uri)
    request = request(uri)
    begin
      response = http.request(request)
    rescue Errno::ECONNREFUSED
      raise 'server not available'
    rescue Errno::ETIMEDOUT
      # oder Timeout::Error ?
      raise 'connection timeout'
    end

    if response.code == '200'
      response.body
    elsif response.code == '401'
      raise 'unauthorized'
    else
      # to do
    end
  end

  def uri(params)
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params) if params
    uri
  end

  def http(uri)
    Net::HTTP.new(uri.host, uri.port)
  end

  def request(uri)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Accept'] = 'application/vnd.api+json'
    request['Authorization'] = auth_token
    request
  end

  def auth_token
    'Basic ' + Base64::encode64("#{username}:#{password}")
  end

  def config_present?
    return true if url && username && password
    false
  end

  def url
    ENV['RAILS_API_URL']
  end

  def username
    ENV['RAILS_API_USER']
  end

  def password
    ENV['RAILS_API_PASSWORD']
  end

  def url_valid?
    uri = URI.parse(url) rescue false
    uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
  end

  def my_company_id
    Company.find_by(company_type: 'mine').id
  end

  def external_company_id
    Company.find_by(company_type: 'external').id
  end

  def example_birthdate
    @birthdate ||= DateTime.new(2000,1,1)
  end

  def is_a_positive_number?(string)
    string !~ /\D/
  end
end
