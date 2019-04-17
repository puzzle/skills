class AddPuzzleTimeKeyToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :puzzle_time_key, :integer
  end
end
