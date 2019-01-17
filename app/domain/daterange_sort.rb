module DaterangeSort
  def by_daterange
    proc do |a, b|
      [:finish_at, :start_at].select do |attr|
        a_date = a[attr]
        b_date = b[attr]

        result = compare_dates(a_date, b_date)
        break result if result.present?
      end.presence || 0
    end
  end

  private

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
