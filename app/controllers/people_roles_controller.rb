class PeopleRolesController < CrudController
  self.permitted_attrs = %i[level percent role_id person_id]

  self.nested_models = %i[person role]

  private

  def fetch_entries
    PeopleRole.includes(:person, :role).list
  end
end
