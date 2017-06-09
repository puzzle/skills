# encoding: utf-8

class Fws < ActiveRecord::Migration[5.1]
  def change
    create_table :expertise_categories do |t|
      t.string :name, null: false
      t.integer :discipline, null: false
    end

    create_table :expertise_topics do |t|
      t.string     :name, null: false
      t.boolean    :user_topic, default: false
      t.references :expertise_category, null: false
    end
    
    create_table :expertise_topic_skill_values do |t|
      t.integer    :years_of_experience
      t.integer    :number_of_projects
      t.integer    :last_use
      t.integer    :skill_level
      t.string     :comment
      t.references :person, null: false
      t.references :expertise_topic, null: false
    end
  end
end
