class AddPtimeEmployeeIdToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :ptime_employee_id, :integer
  end
end
