# frozen_string_literal: true

module DateHelper
  def date_range_label(model_with_dates)
    now = "#{months[model_with_dates.month_from || 0]} #{model_with_dates.year_from} "
    now + date_range_end_label(model_with_dates)
  end

  def months
    t('date.month_names')
  end

  def date_range_end_label(model_with_dates)
    if model_with_dates&.till_today?
      "- #{t('date_range_picker.today')}"
    elsif model_with_dates.same_year? && model_with_dates.same_month?
      ''
    else
      "- #{months[model_with_dates&.month_to || 0]} #{model_with_dates&.year_to}"
    end
  end
end
