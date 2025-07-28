class AddDiscardedAtToDepartment < ActiveRecord::Migration[8.0]
  def change
    add_column :departments, :discarded_at, :datetime
    add_index :departments, :discarded_at
  end
end
