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
      return "- #{t('date_range_picker.today')}"
    elsif !(model_with_dates.same_year? && model_with_dates.same_month?)
      return "- #{months[model_with_dates&.month_to || 0]} #{model_with_dates&.year_to}"
    end

    ''
  end

  def months_with_nil
    months.compact.each_with_index.map { |month, index| [month, index + 1] }
  end

  def last_100_years
    (100.years.ago.year..Time.zone.today.year).to_a.reverse
  end

  def name_of_obj(entry)
    entry.class.to_s.split('::').first.underscore
  end

  def class_of(entry)
    name_of_obj(entry).classify.constantize
  end
end
