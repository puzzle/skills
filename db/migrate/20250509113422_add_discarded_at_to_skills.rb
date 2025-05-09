class AddDiscardedAtToSkills < ActiveRecord::Migration[8.0]
  def change
    add_column :skills, :discarded_at, :datetime
    add_index :skills, :discarded_at
  end
end
