class PuzzleTime::SyncPeopleRolesTask
  class << self
    def sync_people_roles(people)
      person_id_with_roles = people_with_roles(people)
        .map do |person|
          person_id = Person.find_by(puzzle_time_key: person['id']).id
          [ person_id, person['attributes']['employment_roles'] ]
        end

      people_roles_to_create = people_roles_to_create(person_id_with_roles)
      people_roles_to_delete = people_roles_to_delete(person_id_with_roles)

      PeopleRole.delete(people_roles_to_delete)
      PeopleRole.create!(people_roles_to_create)
    end

    private

    # selects only people with roles
    def people_with_roles(people)
      people.select do |person|
        person['attributes']['employment_roles']
      end
    end

    def people_roles_to_create(person_id_with_roles)
      person_id_with_roles
        .flat_map do |(person_id, people_roles)|
          people_roles_to_create_of_person(person_id, people_roles)
        end
    end

    def people_roles_to_delete(person_id_with_roles)
      person_id_with_roles
        .flat_map do |(person_id, people_roles)|
          people_roles_to_delete_of_person(person_id, people_roles)
        end
    end

    def people_roles_to_create_of_person(person_id, people_roles)
      people_roles.map do |people_role|
        role_id = Role.find_by(name: people_role['name']).id

        unless people_role_exists?(person_id, role_id)
          {
            'percent' => people_role['percent'],
            'person_id' => person_id,
            'role_id' => role_id
          }
        end
      end.compact
    end

    def people_role_exists?(person_id, role_id)
      PeopleRole.exists?(person_id: person_id, role_id: role_id)
    end

    def people_roles_to_delete_of_person(person_id, people_roles)
      role_names = people_roles.pluck('name')
      role_ids = Role.where(name: role_names).pluck(:id)

      removed_people_role_ids(person_id, role_ids)
    end

    # ids of people roles which were removed in puzzle time
    def removed_people_role_ids(person_id, role_ids)
      PeopleRole
        .where(person_id: person_id)
        .where.not(role_id: role_ids)
        .pluck(:id)
    end
  end
end
