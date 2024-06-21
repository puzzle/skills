class AddPTimeIdToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :ptime_id, :integer
  end
end
