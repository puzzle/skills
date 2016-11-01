class Person
  class CompetencesController < CrudController
    self.permitted_attrs = [:description, :updated_by]

    def fetch_entries
      Competence.where(person_id: params['person_id'])
    end
  end
end
