class FixPersonAttributes < ActiveRecord::Migration[5.1]
  def up
    change_column_default :people, :origin_person_id, nil

    execute "UPDATE people SET origin_person_id = NULL WHERE ORIGIN_PERSON_ID = -1"

    execute "UPDATE people SET variation_name = NULL WHERE ORIGIN_PERSON_ID IS NULL"
  end
end
