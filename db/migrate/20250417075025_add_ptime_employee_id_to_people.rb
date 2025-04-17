class AddPtimeEmployeeIdToPeople < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :ptime_employee_id, :integer
  end
end
