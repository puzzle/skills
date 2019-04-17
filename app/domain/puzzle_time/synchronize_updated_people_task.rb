class PuzzleTime::SynchronizeUpdatedPeopleTask
  class << self
    attr_reader :updated_people
  
    def synchronize_updated_people(updated_people)
      updated_people = people_attributes_with_key(updated_people)

      updated_people.each do |updated_person|
        puzzle_time_key = updated_person['puzzle_time_key']
        person = Person.find_by(puzzle_time_key: puzzle_time_key)
        attributes = attributes(updated_person)
        person.update_attributes!(attributes)
      end
      # Person.find_by(puzzle_time_key: puzzle_time_keys).update_attributes!(people_to_update)
      # Person.update(puzzle_time_keys, people_to_update)
    end

    private

    def people_attributes_with_key(updated_people)
      updated_people
        .map { |updated_person| 
            pid = updated_person['id'].to_i
            updated_person['attributes'].merge!('puzzle_time_key' => pid)
        }
    end

    def attributes(updated_person)
      {
        'name' => fullname(updated_person),
        'nationality' => updated_person['nationalities'].first,
        'nationality2' => updated_person['nationalities'].second,
        'email' => updated_person['email'],
        'title' => updated_person['graduation'],
        'marital_status' => updated_person['marital_status'],
        'department' => updated_person['department_shortname']
      }
    end
    
    def fullname(updated_person)
      firstname = updated_person['firstname']
      lastname = updated_person['lastname']
      "#{firstname} #{lastname}"
    end
  end
end
