module Person
  class ProjectsController < CrudController
    self.permitted_attrs = [:updated_by, :description, :title, :role, :technology, :year_to]

    def fetch_entries
      Project.where(person_id: params['person_id'])
    end
  end
end
