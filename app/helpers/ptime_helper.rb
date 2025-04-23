module Ptime::PtimeHelper
  def employee_full_name(ptime_employee)
    "#{ptime_employee[:firstname]} #{ptime_employee[:lastname]}"
  end
end
