# frozen_string_literal: true

module DateHelper
  def date_range_label(date_range)
    now = "#{months[date_range.month_from || 0]} #{date_range.year_from} "
    now +=  "- #{t('date_range_picker.today')}" if date_range&.till_today?
    now +=  "- #{months[date_range&.month_to || 0]} #{date_range.year_to}" unless date_range&.till_today? # rubocop:disable Layout/LineLength
    now
  end

  def months
    t('date.month_names')
  end
end
