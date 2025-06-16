# frozen_string_literal: true

class ContributionsController < People::PersonRelationsController
  self.permitted_attrs = %i[title link person_id display_in_cv year_from year_to month_from
                            month_to]
end
