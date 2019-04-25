class PuzzleTime::SyncUpdatedPeopleTask
  class << self
    attr_reader :updated_people
  
    def sync_updated_people(updated_people)
      people_attributes(updated_people).each do |updated_person|
        puzzle_time_key = updated_person['puzzle_time_key']
        person = Person.find_by(puzzle_time_key: puzzle_time_key)
        attributes = attributes(updated_person)
        person.update_attributes!(attributes)
      end
    end

    private

    def people_attributes(updated_people)
      updated_people
        .map do |updated_person|
          puzzle_time_key = updated_person['id'].to_i
          updated_person['attributes'].merge!('puzzle_time_key' => puzzle_time_key)
        end.compact
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
