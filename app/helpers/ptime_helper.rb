module PtimeHelper
  def employee_full_name(ptime_employee)
    "#{ptime_employee[:firstname]} #{ptime_employee[:lastname]}"
  end

  MAX_NUMBER_OF_FETCHED_EMPLOYEES = 1000
end
