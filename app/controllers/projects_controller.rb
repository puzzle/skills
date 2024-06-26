# frozen_string_literal: true

class ProjectsController < People::PersonRelationsController
  self.permitted_attrs = %i[description title role technology
                            month_from year_from month_to year_to person_id]
end
