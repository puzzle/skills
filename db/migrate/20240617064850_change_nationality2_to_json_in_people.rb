class ChangeNationality2ToJsonInPeople < ActiveRecord::Migration[7.0]
  def up
    change_column :people, :nationality2, :json, using: %q{to_json(regexp_split_to_array(nationality2, E'\\\\s+'))}
  end
  
  def down
    delete_column :people, :nationality2
  end
end
