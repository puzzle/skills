class PuzzleTime::MarkExEmployeesTask
  class << self
    attr_reader :people
  
    def mark_ex_employees(people)
      @people = people

      Person.where(puzzle_time_key: ex_employee_ids).update_all(company_id: external_company_id)
    end
    
    private

    def ex_employee_ids
      puzzle_skills_ids - puzzle_time_ids
    end

    def puzzle_time_ids
      people.map { |person| person.values[0].to_i }
    end

    def puzzle_skills_ids
      Person.all.pluck(:puzzle_time_key).compact
    end
    
    def external_company_id
      Company.external.first.id
    end
  end
end
