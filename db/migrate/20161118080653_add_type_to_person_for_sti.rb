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
    Person.all.find_each do |p|
      next if p.origin_person_id.nil?
      p.update_column(:type, Person::Variation)
    end
  end
end
