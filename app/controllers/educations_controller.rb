class EducationsController < PersonRelationsController
  self.permitted_attrs = %i[location title finish_at start_at person_id]
end
