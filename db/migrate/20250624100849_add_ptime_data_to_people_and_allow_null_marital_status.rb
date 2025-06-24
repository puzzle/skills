class AddPtimeDataToPeopleAndAllowNullMaritalStatus < ActiveRecord::Migration[8.0]
  def change
    add_column :people, :ptime_data_provider, :string
    add_column :people, :ptime_employee_id, :integer
    change_column_null :people, :marital_status, true, 0
  end
end
