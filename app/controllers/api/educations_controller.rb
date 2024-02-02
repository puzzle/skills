# frozen_string_literal: true

class Api::EducationsController < Api::PersonRelationsController
  self.permitted_attrs = %i[location title month_to year_to month_from year_from person_id]
end
