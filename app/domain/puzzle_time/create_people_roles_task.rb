class PuzzleTime::CreatePeopleRolesTask
  class << self
    def create_people_roles(people)
      #TODO: fetch all people and roles in one query
      #puzzle_time_keys = people_with_roles.pluck('puzzle_time_key')
      #people = Person.find_by(puzzle_time_key: puzzle_time_keys)

      people_roles_to_create = people_with_roles(people)
        .flat_map do |person|
          person_id = Person.find_by(puzzle_time_key: person['puzzle_time_key']).id
          people_roles = person['employment_roles']

          delete_removed_people_roles(person_id, people_roles)

          people_roles_to_create(person_id, people_roles)
      end.compact

      PeopleRole.create!(people_roles_to_create)
    end

    private

    def people_with_roles(people)
      people
        .pluck('attributes')
        .select { |person| person['employment_roles'] }
    end

    def people_roles_to_create(person_id, people_roles)
      people_roles.each do |people_role|
        role_id = Role.find_by(name: people_role.delete('name')).id
        return if people_role_exists?(person_id, role_id)

        people_role.merge!(
          'person_id' => person_id,
          'role_id' => role_id 
        )
      end
    end

    def people_role_exists?(person_id, role_id)
      PeopleRole.exists?(person_id: person_id, role_id: role_id) 
    end

    def delete_removed_people_roles(person_id, people_roles)
          role_names = people_roles.pluck('name')
          role_ids = Role.where(name: [role_names]).pluck(:id)
          
          removed_ids = removed_ids(person_id, role_ids)
          PeopleRole.delete(removed_ids)
    end

    def removed_ids(person_id, role_ids)
      old_ids(person_id) - new_ids(person_id, role_ids)
    end

    def old_ids(person_id)
      PeopleRole
        .where(person_id: person_id)
        .pluck(:id)
    end

    def new_ids(person_id, role_ids)
      PeopleRole
        .where(person_id: person_id, role_id: role_ids)
        .pluck(:id)
    end
  end
end
