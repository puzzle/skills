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
        t.timestamp :updated_at
        t.string :updated_by
        t.datetime :created_at
        t.string :name
        t.string :origin
        t.string :role
        t.string :title
        t.integer :status_id
        t.integer :origin_person_id
        t.string :variation_name
        t.timestamp :variation_date
      end

      create_table :advanced_trainings do |t|
        t.text :description
        t.timestamp :updated_at
        t.string :updated_by
        t.datetime :created_at
        t.integer :year_from
        t.integer :year_to
        t.integer :person_id
      end

      create_table :activities do |t|
        t.text :description
        t.timestamp :updated_at
        t.string :updated_by
        t.datetime :created_at
        t.text :role
        t.integer :year_from
        t.integer :year_to
        t.integer :person_id
      end

      create_table :projects do |t|
        t.timestamp :updated_at
        t.string :updated_by
        t.datetime :created_at
        t.text :description
        t.text :title
        t.text :role
        t.text :technology
        t.integer :year_to
        t.integer :person_id
      end

      create_table :educations do |t|
        t.text :location
        t.text :type
        t.timestamp :updated_at
        t.string :updated_by
        t.integer :year_from
        t.integer :year_to
        t.integer :person_id
      end

      create_table :competences do |t|
        t.text :description
        t.timestamp :updated_at
        t.string :updated_by
        t.integer :person_id
      end
    end
  end
end
