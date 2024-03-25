# frozen_string_literal: true

class AdvancedTrainingsController < PersonRelationsController
  self.permitted_attrs = %i[description year_to month_to year_from month_from person_id]
  self.nilified_attrs_if_missing = [:year_to, :month_to]

  private

  def entry # rubocop:disable Metrics/AbcSize
    relation = super
    if relation.id.nil?
      relation.month_from ||= 2
      relation.year_from ||= Time.zone.today.year - 1

      relation.month_to ||= Time.zone.today.month + 1
      relation.year_to ||= Time.zone.today.year
    end
    relation
  end
end
