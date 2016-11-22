class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def start_must_be_before_end_time
    return if year_from.nil? || year_to.nil?
    errors.add(:year_from, 'must be higher than year from') if year_from > year_to
  end
end
