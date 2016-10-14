class LegacySchema < ActiveRecord::Migration[5.0]
  def change
    # diese migration wird nur ausgeführt wenn die datenbank bereits mit einem älteren schema existiert
    ActiveRecord::Base.connection.tables
    unless ActiveRecord::Base.connection.table_exists? 'person'
      create_table :status do |t|
        t.string :status
      end

      create_table :person do |t|
        t.timestamp :birthdate
        t.column :image, 'bytea', null: false
        t.string :language
        t.string :location
        t.string :martialstatus
        t.timestamp :moddate
        t.string :moduser
        t.string :name
        t.string :origin
        t.string :role
        t.string :title
        t.integer :fk_status
        t.integer :rel_id
        t.string :variation_name
        t.timestamp :variation_date
      end

      create_table :advancedtraining do |t|
        t.text :description
        t.timestamp :moddate
        t.string :moduser
        t.integer :yearfrom
        t.integer :yearto
        t.integer :fk_person
      end

      create_table :activity do |t|
        t.text :description
        t.timestamp :moddate
        t.string :moduser
        t.text :role
        t.integer :yearfrom
        t.integer :yearto
        t.integer :fk_person
      end

      create_table :project do |t|
        t.timestamp :moddate
        t.string :moduser
        t.text :projectdescription
        t.text :projecttitle
        t.text :role
        t.text :technology
        t.integer :yearto
        t.integer :fk_person
      end

      create_table :education do |t|
        t.text :educationlocation
        t.text :educationtype
        t.timestamp :moddate
        t.string :moduser
        t.integer :yearfrom
        t.integer :yearto
        t.integer :fk_person
      end

      create_table :competence do |t|
        t.text :description
        t.timestamp :moddate
        t.string :moduser
        t.integer :fk_person
      end
    end
  end
end
