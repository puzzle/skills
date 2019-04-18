class PuzzleTime::CreateRolesTask
  class << self
    attr_reader :people
    
    def create_roles(people)
      @people = people

      if role_names
        Role.create!(new_role_attributes)
      end
    end

    private

    def new_role_attributes
      new_role_names.collect do |new_role_name|
        Hash['name', new_role_name]
      end
    end
    
    def new_role_names
      role_names.map do |role_name|
        Role.exists?(:name => role_name)? nil : role_name 
      end.compact
    end
    
    def role_names
      people_attributes.flat_map do |person|
        person['employment_roles'].pluck('name')
      end.uniq
    end
    
    def people_attributes
      people.map do |person|
        puzzle_time_key = person['id'].to_i
        person['attributes'].merge!('puzzle_time_key' => puzzle_time_key)
      end.compact
    end
  end
end
