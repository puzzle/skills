# frozen_string_literal: true

class PeopleController < CrudController
  include ExportController

  self.permitted_attrs = %i[birthdate location
                            marital_status updated_by name nationality nationality2 title
                            competence_notes company_id email department_id shortname]

  self.nested_models = %i[advanced_trainings activities projects
                          educations language_skills person_roles
                          people_skills categories]

  self.permitted_relationships = %i[person_roles people_skills]

end
