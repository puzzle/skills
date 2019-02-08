class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  private

  def start_at_before_finish_at
    return if finish_at.nil? || start_at.nil?
    errors.add(:start_at, 'muss vor "Datum bis" sein') if start_at > finish_at
  end

  def daterange_year_length
    msg = 'enthält ein zu kurzes Jahr (4 Ziffern)'
    { start_at: start_at, finish_at: finish_at }.each do |key, value|
      next if value.nil?
      errors.add(key, msg) unless value.year.to_i.between?(1000, 9999)
    end
  end
end
