class CreateCertificates < ActiveRecord::Migration[8.0]
  def change
    create_table :certificates do |t|
      t.string :name, null: false
      t.decimal :points_value, null: false
      t.string :description
      t.string :provider
      t.integer :course_duration
      t.integer :exam_duration
      t.string :type_of_exam
      t.integer :study_time
      t.text :notes

      t.timestamps
    end
  end
end
