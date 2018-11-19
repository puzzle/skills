class RemoveVariations < ActiveRecord::Migration[5.2]

  def up
    remove_variations
    remove_column :people, :variation_name
    remove_column :people, :origin_person_id
    remove_column :people, :type
  end

  def down
    add_column :people, :variation_name, :string
    add_column :people, :origin_person_id, :integer
    add_column :people, :type, :string
  end

  private

  def remove_variations
    # do this by plain SQL since Person::Variation doesn't exist anymore
    connection = ActiveRecord::Base.connection
    connection.execute("DELETE FROM people WHERE type='Person::Variation'")
  end

end
