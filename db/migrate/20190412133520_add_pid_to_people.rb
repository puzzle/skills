class AddPidToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :puzzle_time_id, :integer
  end
end
