class Person::EducationsController < CrudController
  self.permitted_attrs = [:location, :title, :year_from, :year_to]

  def fetch_entries
    Education.where(person_id: params['person_id'])
  end
end
