class PeopleSync::CreateRolesTask
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
      role_names.reject do |role_name|
        Role.exists?(:name => role_name)
      end
    end
    
    def role_names
      people_attributes.flat_map do |person|
        person['employment_roles'].pluck('name')
      end.uniq
    end
    
    def people_attributes
      people.map do |person|
        remote_key = person['id'].to_i
        person['attributes'].merge!('remote_key' => remote_key)
      end.compact
    end
  end
end
