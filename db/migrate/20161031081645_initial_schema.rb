class InitialSchema < ActiveRecord::Migration[5.0]
  def change
    ActiveRecord::Base.connection.tables
    unless ActiveRecord::Base.connection.table_exists? 'person'
      create_table :statuses do |t|
        t.string :status
      end

      create_table :people do |t|
        t.timestamp :birthdate
        t.column :profile_picture, 'bytea', null: false
        t.string :language
        t.string :location
        t.string :martial_status
        t.string :updated_by
        t.string :name
        t.string :origin
        t.string :role
        t.string :title
        t.references :status
        t.integer :origin_person_id
        t.string :variation_name
        t.timestamp :variation_date
        t.timestamps
      end

      create_table :advanced_trainings do |t|
        t.text :description
        t.string :updated_by
        t.integer :year_from
        t.integer :year_to
        t.references :person
        t.timestamps
      end

      create_table :activities do |t|
        t.text :description
        t.string :updated_by
        t.text :role
        t.integer :year_from
        t.integer :year_to
        t.timestamps
        t.references :person
      end

      create_table :projects do |t|
        t.string :updated_by
        t.text :description
        t.text :title
        t.text :role
        t.text :technology
        t.integer :year_to
        t.timestamps
        t.references :person
      end

      create_table :educations do |t|
        t.text :location
        t.text :title
        t.timestamp :updated_at
        t.string :updated_by
        t.integer :year_from
        t.integer :year_to
        t.references :person
      end

      create_table :competences do |t|
        t.text :description
        t.timestamp :updated_at
        t.string :updated_by
        t.references :person
      end
    end
  end
end
