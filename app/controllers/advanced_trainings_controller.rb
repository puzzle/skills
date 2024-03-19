# frozen_string_literal: true

class AdvancedTrainingsController < CrudController
  self.permitted_attrs = %i[description year_to month_to year_from month_from person_id]
  self.nilified_attrs_if_missing = [:year_to, :month_to]

  def update
    super(:location => person_path(entry.person))
  end
end
