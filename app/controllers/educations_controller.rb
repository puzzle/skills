# frozen_string_literal: true

class EducationsController < PersonRelationsController
  self.permitted_attrs = %i[location title year_to month_to year_from month_from person_id]
  self.nilified_attrs_if_missing = [:year_to, :month_to]
  skip_before_action :entry, only: %i[new]
  before_action :new_entry, only: %i[new]

  private

  def new_entry # rubocop:disable Metrics/AbcSize
    relation = entry
    if relation.id.nil?
      relation.month_from ||= 2
      relation.year_from ||= Time.zone.today.year - 1

      relation.month_to ||= Time.zone.today.month + 1
      relation.year_to ||= Time.zone.today.year
    end
  end
end
