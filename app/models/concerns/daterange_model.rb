# frozen_string_literal: true

module DaterangeModel
  extend ActiveSupport::Concern

  included do
    validates :year_from, presence: true
    validates :year_from, :year_to, numericality: { less_than_or_equal_to: 9999,
                                                    greater_than_or_equal_to: 1000,
                                                    allow_nil: true }
    validates :month_from, :month_to, numericality: { less_than_or_equal_to: 12,
                                                      greater_than_or_equal_to: 1,
                                                      allow_nil: true }
    validates :month_to, absence: true, unless: proc { |r| r.year_to }
    validate :start_at_before_finish_at

    scope :list, lambda {
      order(Arel.sql('year_to IS NOT NULL, year_to desc, month_to IS NULL, month_to
                                desc, year_from desc, month_from IS NULL, month_from desc'))
    }
  end

  private

  def start_at_before_finish_at
    return if year_from.nil? || year_to.nil?
    formatted_month_from = month_from || 1
    formatted_month_to = month_to || 12
    start_at = Date.new(year_from, formatted_month_from)
    finish_at = Date.new(year_to, formatted_month_to)
    errors.add(:year_from, 'muss vor "Datum bis" sein') if start_at > finish_at
  end
end
