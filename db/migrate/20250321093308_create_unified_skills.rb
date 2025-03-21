class CreateUnifiedSkills < ActiveRecord::Migration[8.0]
  def change
    create_table :unified_skills do |t|
      t.text :skill_1_attrs
      t.text :skill_2_attrs
      t.text :unified_skill_attrs

      t.timestamps
    end
  end
end
