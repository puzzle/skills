module PtimeHelper
  def employee_full_name(ptime_employee)
    "#{ptime_employee[:firstname]} #{ptime_employee[:lastname]}"
  end

  MAX_PAGE_SIZE = 1000
end
