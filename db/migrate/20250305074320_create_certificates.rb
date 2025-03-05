class CreateCertificates < ActiveRecord::Migration[8.0]
  def change
    create_table :certificates do |t|
      t.string :name, null: false
      t.decimal :points_value, null: false
      t.string :description, null: false
      t.string :provider
      t.integer :exam_duration, null: false
      t.string :type_of_exam, null: false
      t.integer :study_time, null: false
      t.text :notes

      t.timestamps
    end
  end
end
