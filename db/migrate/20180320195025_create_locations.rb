class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :location
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
