class AddTypeToPersonForSti < ActiveRecord::Migration[5.0]
  def up
    add_column :people, :type, :string
    migrate_variations
  end

  def down
    remove_column :people, :type
  end

  private

  def migrate_variations
    execute "UPDATE people SET type = 'Person::Variation' WHERE origin_person_id IS NOT NULL"
  end
end
