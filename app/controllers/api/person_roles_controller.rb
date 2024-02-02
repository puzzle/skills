# frozen_string_literal: true

class Api::PersonRolesController < Api::CrudController
  self.permitted_attrs = %i[percent role_id person_id person_role_level_id]

  self.nested_models = %i[person role]

  private

  def fetch_entries
    PersonRole.includes(:person, :role).list
  end
end
