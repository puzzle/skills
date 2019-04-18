class PuzzleTime::CreatePeopleTask
  class << self
    attr_reader :people

    def create_people(people)
      @people = people

      people_to_create = new_people.map do |new_person|
        attributes(new_person).merge(not_included_attributes)
      end

      Person.create!(people_to_create)
    end
    
    private

    def new_people
      people.map do |person|
        puzzle_time_key = person['id'].to_i
        if new_ids.include? puzzle_time_key
          person['attributes'].merge!('puzzle_time_key' => puzzle_time_key)
        end
      end.compact
    end

    def new_ids
      puzzle_time_ids - puzzle_skills_ids
    end

    def puzzle_time_ids
      people.pluck('id').map(&:to_i)
    end

    def puzzle_skills_ids
      Person.all.pluck(:puzzle_time_key).compact
    end

    def attributes(new_person)
      {
        'puzzle_time_key' => new_person['puzzle_time_key'],
        'name' => fullname(new_person),
        'nationality' => new_person['nationalities'].first,
        'nationality2' => new_person['nationalities'].second,
        'email' => new_person['email'],
        'title' => new_person['graduation'],
        'marital_status' => new_person['marital_status'],
        'department' => new_person['department_shortname']
      }
    end
    
    def fullname(new_person)
      firstname = new_person['firstname']
      lastname = new_person['lastname']
      "#{firstname} #{lastname}"
    end
    
    # mandatory attributes that api does not include
    def not_included_attributes
      {
        'company_id' => my_company_id,
        'birthdate' => example_birthdate,
        'location' => 'Bern'
      }
    end
    
    def my_company_id
      Company.mine.first.id
    end

    def example_birthdate
      @birthdate ||= DateTime.new(2000,1,1)
    end
  end
end
