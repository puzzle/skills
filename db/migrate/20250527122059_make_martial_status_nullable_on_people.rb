class MakeMartialStatusNullableOnPeople < ActiveRecord::Migration[8.0]
  def change
    change_column_null :people, :marital_status, true, 0
  end
end
