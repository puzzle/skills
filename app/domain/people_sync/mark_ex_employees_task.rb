class PeopleSync::MarkExEmployeesTask
  class << self
    attr_reader :people
  
    def mark_ex_employees(people)
      @people = people

      Person.where(remote_key: ex_employee_ids)
        .update_all(company_id: external_company_id)
    end
    
    private

    def ex_employee_ids
      puzzle_skills_ids - remote_ids
    end

    def remote_ids
      people.map { |person| person['id'].to_i }
    end

    def puzzle_skills_ids
      Person.all.pluck(:remote_key).compact
    end
    
    def external_company_id
      Company.external.first.id
    end
  end
end
