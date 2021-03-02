class PeopleSync::CreatePeopleTask
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

    # only in remote system existing people
    def new_people
      people.map do |person|
        remote_key = person['id'].to_i
        if new_ids.include? remote_key
          person['attributes'].merge!('remote_key' => remote_key)
        end
      end.compact
    end

    def new_ids
      remote_ids - puzzle_skills_ids
    end

    def remote_ids
      people.pluck('id').map(&:to_i)
    end

    def puzzle_skills_ids
      Person.all.pluck(:remote_key).compact
    end

    def attributes(new_person)
      {
        'remote_key' => new_person['remote_key'],
        'name' => fullname(new_person),
        'nationality' => new_person['nationalities'].first,
        'nationality2' => new_person['nationalities'].second,
        'email' => new_person['email'],
        'title' => new_person['graduation'],
        'marital_status' => new_person['marital_status']
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
        'company' =>  {name: 'firma123'},
        'company_id' => 1,
        'birthdate' => example_birthdate,
        'location' => 'Bern',
        'department_id' => 1
      }
    end

    def example_birthdate
      @birthdate ||= DateTime.new(2000,1,1)
    end

  end
end
