class PuzzleTime::PeopleFilter
  attr_reader :people
  
  STRING_ATTRIBUTES = ['firstname', 'lastname', 'email', 'marital_status',
                       'graduation', 'department_shortname'].freeze

  def initialize(people)
    @people = people
  end

  # returns array with hashes of valid people
  def filter
    return [] if people.empty?
    people.select do |person|
      if valid?(person)
        true
      else
        Airbrake.notify('person not valid', { person: person })
        false
      end
    end
  end

  private

  # checks if person valid
  def valid?(person)
    pid_valid?(person) && attributes_valid?(person)
  rescue
    false
  end

  # checks if pid is a positive number
  def pid_valid?(person)
    pid = person.values[0]
    pid.to_i.positive?
  end

  # checks if mandatory attributes present and valid
  def attributes_valid?(person)
    attributes = person.values[2]

    # checks all attributes which should be strings 
    STRING_ATTRIBUTES.each do |attribute|
      return unless attributes[attribute].is_a?(String)
    end

    return unless attributes['nationalities'].is_a?(Array)
    return unless roles_valid?(attributes)
    true
  end

  def roles_valid?(attributes)
    attributes['employment_roles'].each do |role|
      return unless role['name'].is_a?(String)
      return unless role['percent'].is_a?(Float)
    end
  end
end
