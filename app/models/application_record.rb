class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private
  def year_from_before_year_to
    return if year_from.nil? || year_to.nil?
    errors.add(:year_from, 'must be before year to') if year_from > year_to
  end
end
