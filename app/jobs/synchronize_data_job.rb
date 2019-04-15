require 'net/http'
require 'uri'
require 'json'

class SynchronizeDataJob < CronJob

  queue_as :default

  self.cron_expression = '47 2 * * *'

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do something with the exception
  end

  def perform
    return unless config_present?
    return unless url_valid?

    mark_ex_employees(removed_ids)
    create_new_employees(new_ids)
  end

  private

  def mark_ex_employees(ex_employee_ids)
    Person.where(id: ex_employee_ids).update_all(company_id: external_company_id)
  end

  def create_new_employees(new_employee_ids)
    @people_roles = []

    create_new_roles
    create_new_people
    create_new_people_roles
  end

  def create_new_roles
    if role_names
      Role.create!(new_role_attributes(role_names))
    end
  end

  def new_role_attributes(role_names)
    new_role_names(role_names).collect do |new_role_name|
      Hash['name', new_role_name]
    end
  end
  
  def new_role_names(role_names)
    role_names.map do |role_name|
      Role.exists?(:name => role_name)? nil : role_name 
    end.compact
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

  def set_people_roles(employment_roles, pid)
    @people_roles << employment_roles.map do |employment_role|
      employment_role.merge!('pid' => pid)
    end.first
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

  def removed_ids
    puzzle_skills_ids - puzzle_time_ids
  end

  def puzzle_time_ids
    @puzzle_time_ids ||= people_hash.map { |person| person.values[0].to_i }
  end

  def puzzle_skills_ids
    @puzzle_skills_ids ||= Person.all.pluck(:puzzle_time_id).compact
  end
  
  def new_people_attributes
    @new_people_attributes ||= people_hash.map do |person|
      pid = person.values[0].to_i
      if new_ids.include? pid
        person.values[2].merge!('puzzle_time_id' => pid)
      end
    end.compact
  end

  def role_names
    @role_names ||= new_people_attributes.map do |new_person|
      new_person['employment_roles'].map do |person_roles|
        person_roles.values[0]
      end.first
    end.uniq
  end
  
  def my_company_id
    Company.find_by(company_type: 'mine').id
  end

  def external_company_id
    Company.find_by(company_type: 'external').id
  end

  def people_hash
    @people_hash ||= JSON.parse(response)['data']
  end

  def response
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    # erwartet das json zurückgegeben wird
    request['Accept'] = 'application/vnd.api+json'
    request['Authorization'] = auth_token
    begin
      response = http.request(request)
    rescue Errno::ECONNREFUSED
      return
      # sever not available
    end
    if response.code == '200'
      response.body
    elsif response.code == '401'
      raise 'Unauthorized'
    else
      # to do
    end
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

  def example_birthdate
    @birthdate ||= DateTime.new(2000,1,1)
  end
end
