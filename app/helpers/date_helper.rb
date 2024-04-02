# frozen_string_literal: true

module DateHelper
  def date_range_label(date_range)
    now = "#{months[date_range.month_from || 0]} #{date_range.year_from} "
    now += date_range&.till_today? ? "- #{today_label}" : date_range_end_label(date_range)
    now
  end

  def months
    t('date.month_names')
  end

  def today_label
    t('date_range_picker.today')
  end

  def date_range_end_label(date_range)
    "- #{months[date_range&.month_to || 0]} #{date_range.year_to}"
  end
end
