module SortByDaterange
  def sort_by_daterange
    @sort_by_daterange ||= proc do |a, b|
      result = nil
      [:finish_at, :start_at].each do |attr|
        a_date = a[attr]
        b_date = b[attr]

        result ||= compare_dates(a_date, b_date)
      end

      result || 0
    end
  end

  def compare_dates(date1, date2)
    result ||= check_for_today(date1, date2)
    if date1.present? && date2.present?
      result ||= check_for_thirteenth(date1, date2)
      result ||= date2 - date1 if date2 != date1
    end
    result
  end

  def check_for_today(date1, date2)
    return -1 if date1.nil? && date2.present?
    return 1 if date1.present? && date2.nil?
  end

  def check_for_thirteenth(date1, date2)
    if date1.year == date2.year
      return 1 if date1.day == 13 && date2.day != 13
      return -1 if date1.day != 13 && date2.day == 13
    end
  end
end
