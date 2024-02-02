# frozen_string_literal: true

class Api::ExpertiseCategoriesController < Api::CrudController
  self.permitted_attrs = %i[name discipline]

  self.nested_models = %i[expertise_topic]

  def fetch_entries
    raise unless params[:discipline]

    ExpertiseCategory.list(params[:discipline])
  end
end
